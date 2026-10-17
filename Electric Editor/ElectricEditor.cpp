#include <windows.h>
#include <d3d11.h>
#include <filesystem>
#include <fstream>
#include <string>
#include <cstdio>
#include <cmath>
#include <regex>
#include <sstream>

#include "imgui.h"
#include "imgui_impl_win32.h"
#include "imgui_impl_dx11.h"

#pragma comment(lib, "d3d11.lib")

//------------------------------------------------------------
// DATA
//------------------------------------------------------------

struct EffectSet
{
    ImVec4 Main = ImVec4(0, 1, 1, 1);
    ImVec4 Glow = ImVec4(1, 1, 1, 1);
    ImVec4 Outline = ImVec4(0.7f, 1, 1, 1);

    float MainIntensity = 10.f;
    float GlowIntensity = 3.f;
    float OutlineIntensity = 1.f;
};

struct Config
{
    EffectSet Kazuya;

    EffectSet ReinaCD2;
    EffectSet ReinaCD3;

    EffectSet HeihachiEWGF;
    EffectSet HeihachiCD1;

    EffectSet Jin;
    EffectSet DevilJin;
};

Config cfg;

struct EffectEntry
{
    const char* Tab;
    const char* Title;
    const char* Prefix;
    EffectSet* Set;
};

EffectEntry g_Effects[] =
{
    { "Kazuya",    "Electric",      "",            &cfg.Kazuya       },

    { "Reina",     "CD2 Electric",  "Reina",       &cfg.ReinaCD2     },
    { "Reina",     "CD3 Kick",      "ReinaKick",   &cfg.ReinaCD3     },

    { "Heihachi",  "EWGF",          "Heihachi",    &cfg.HeihachiEWGF },
    { "Heihachi",  "CD1 Electric",  "HeihachiCD1", &cfg.HeihachiCD1  },

    { "Jin",       "CD1 & CD2",     "Jin",         &cfg.Jin          },

    { "Devil Jin", "CD1 & CD2",     "DevilJin",    &cfg.DevilJin     },
};

const char* g_Tabs[] = { "Kazuya", "Reina", "Heihachi", "Jin", "Devil Jin" };

//------------------------------------------------------------
// PATHS
//------------------------------------------------------------

std::filesystem::path Root()
{
    wchar_t path[MAX_PATH];
    GetModuleFileNameW(nullptr, path, MAX_PATH);
    return std::filesystem::path(path).parent_path();
}

//------------------------------------------------------------
// HEX HELPERS
//------------------------------------------------------------

static int ToByte(float v)
{
    long b = std::lround(v * 255.f);
    if (b < 0) b = 0;
    if (b > 255) b = 255;
    return (int)b;
}

std::string Hex(ImVec4 c)
{
    char out[8];

    sprintf_s(out,
        "#%02X%02X%02X",
        ToByte(c.x),
        ToByte(c.y),
        ToByte(c.z));

    return out;
}

bool HexToColor(const std::string& hex, ImVec4& out)
{
    if (hex.size() != 7 || hex[0] != '#')
        return false;

    try
    {
        int r = std::stoi(hex.substr(1, 2), nullptr, 16);
        int g = std::stoi(hex.substr(3, 2), nullptr, 16);
        int b = std::stoi(hex.substr(5, 2), nullptr, 16);

        out = ImVec4(r / 255.f, g / 255.f, b / 255.f, 1.f);
        return true;
    }
    catch (...)
    {
        return false;
    }
}

//------------------------------------------------------------
// FILE IO
//------------------------------------------------------------

bool ReadString(const std::string& text, const std::string& key, std::string& out)
{
    std::regex rgx("\\b" + key + R"re(\s*=\s*"([^"]+)")re");
    std::smatch m;

    if (std::regex_search(text, m, rgx))
    {
        out = m[1].str();
        return true;
    }

    return false;
}

bool ReadFloat(const std::string& text, const std::string& key, float& out)
{
    std::regex rgx("\\b" + key + R"(\s*=\s*(-?[0-9]*\.?[0-9]+))");
    std::smatch m;

    if (std::regex_search(text, m, rgx))
    {
        try { out = std::stof(m[1].str()); return true; }
        catch (...) {}
    }

    return false;
}

void LoadSet(const std::string& text, const std::string& prefix, EffectSet& e)
{
    std::string s;

    if (ReadString(text, prefix + "MainColor", s))    HexToColor(s, e.Main);
    if (ReadString(text, prefix + "GlowColor", s))    HexToColor(s, e.Glow);
    if (ReadString(text, prefix + "OutlineColor", s)) HexToColor(s, e.Outline);

    ReadFloat(text, prefix + "MainIntensity", e.MainIntensity);
    ReadFloat(text, prefix + "GlowIntensity", e.GlowIntensity);
    ReadFloat(text, prefix + "OutlineIntensity", e.OutlineIntensity);
}

void LoadConfig()
{
    auto path = Root() / "Scripts" / "config.lua";

    if (!std::filesystem::exists(path))
        return;

    std::ifstream file(path);

    std::stringstream buffer;
    buffer << file.rdbuf();

    std::string text = buffer.str();

    for (auto& fx : g_Effects)
        LoadSet(text, fx.Prefix, *fx.Set);
}

void WriteSet(std::ofstream& f, const std::string& prefix, const EffectSet& e)
{
    f << prefix << "MainColor = \"" << Hex(e.Main) << "\",\n";
    f << prefix << "GlowColor = \"" << Hex(e.Glow) << "\",\n";
    f << prefix << "OutlineColor = \"" << Hex(e.Outline) << "\",\n";

    f << prefix << "MainIntensity = " << e.MainIntensity << ",\n";
    f << prefix << "GlowIntensity = " << e.GlowIntensity << ",\n";
    f << prefix << "OutlineIntensity = " << e.OutlineIntensity << ",\n\n";
}

bool SaveConfig()
{
    auto root = Root();

    std::filesystem::create_directories(root / "Scripts");

    std::ofstream f(root / "Scripts" / "config.lua");
    if (!f)
        return false;

    f << "return {\n\n";

    for (auto& fx : g_Effects)
        WriteSet(f, fx.Prefix, *fx.Set);

    f << "}\n";
    f.close();

    std::ofstream(root / "reload.flag");
    return true;
}

//------------------------------------------------------------
// DX11
//------------------------------------------------------------

static ID3D11Device* device = nullptr;
static ID3D11DeviceContext* context = nullptr;
static IDXGISwapChain* swapchain = nullptr;
static ID3D11RenderTargetView* rtv = nullptr;

void CreateRT()
{
    ID3D11Texture2D* bb = nullptr;
    swapchain->GetBuffer(0, IID_PPV_ARGS(&bb));
    device->CreateRenderTargetView(bb, nullptr, &rtv);
    bb->Release();
}

void CleanupRT()
{
    if (rtv)
    {
        rtv->Release();
        rtv = nullptr;
    }
}

bool CreateDevice(HWND hwnd)
{
    DXGI_SWAP_CHAIN_DESC sd{};
    sd.BufferCount = 2;
    sd.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    sd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    sd.OutputWindow = hwnd;
    sd.SampleDesc.Count = 1;
    sd.Windowed = TRUE;

    if (D3D11CreateDeviceAndSwapChain(
        nullptr,
        D3D_DRIVER_TYPE_HARDWARE,
        nullptr,
        0,
        nullptr,
        0,
        D3D11_SDK_VERSION,
        &sd,
        &swapchain,
        &device,
        nullptr,
        &context) != S_OK)
        return false;

    CreateRT();
    return true;
}

void CleanupDevice()
{
    CleanupRT();

    if (swapchain) swapchain->Release();
    if (context) context->Release();
    if (device) device->Release();
}

//------------------------------------------------------------
// WINDOW
//------------------------------------------------------------

extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND, UINT, WPARAM, LPARAM);

LRESULT CALLBACK WndProc(HWND h, UINT m, WPARAM w, LPARAM l)
{
    if (ImGui_ImplWin32_WndProcHandler(h, m, w, l))
        return 1;

    switch (m)
    {
    case WM_SIZE:

        if (device && w != SIZE_MINIMIZED)
        {
            CleanupRT();

            swapchain->ResizeBuffers(
                0,
                LOWORD(l),
                HIWORD(l),
                DXGI_FORMAT_UNKNOWN,
                0);

            CreateRT();
        }

        return 0;

    case WM_DESTROY:

        PostQuitMessage(0);
        return 0;
    }

    return DefWindowProc(h, m, w, l);
}

//------------------------------------------------------------
// UI
//------------------------------------------------------------

void DrawEffect(const char* id, const char* title, EffectSet& e)
{
    ImGui::PushID(id);

    if (ImGui::CollapsingHeader(title, ImGuiTreeNodeFlags_DefaultOpen))
    {
        ImGui::Text("Main Bolt");
        ImGui::ColorEdit3("##Main", (float*)&e.Main);
        ImGui::SliderFloat("Intensity##Main", &e.MainIntensity, 0, 20);

        ImGui::Separator();

        ImGui::Text("Glow");
        ImGui::ColorEdit3("##Glow", (float*)&e.Glow);
        ImGui::SliderFloat("Intensity##Glow", &e.GlowIntensity, 0, 20);

        ImGui::Separator();

        ImGui::Text("Outline");
        ImGui::ColorEdit3("##Outline", (float*)&e.Outline);
        ImGui::SliderFloat("Intensity##Outline", &e.OutlineIntensity, 0, 20);
    }

    ImGui::PopID();
}

//------------------------------------------------------------
// MAIN
//------------------------------------------------------------

int WINAPI WinMain(HINSTANCE hInst, HINSTANCE, LPSTR, int)
{
    WNDCLASSEX wc{
        sizeof(wc),
        CS_CLASSDC,
        WndProc,
        0,0,
        hInst,
        nullptr,nullptr,nullptr,nullptr,
        L"ElectricEditor",
        nullptr
    };

    RegisterClassEx(&wc);

    HWND hwnd = CreateWindow(
        wc.lpszClassName,
        L"Electric Recolor Tool",
        WS_OVERLAPPEDWINDOW,
        100, 100,
        720, 560,
        nullptr, nullptr,
        wc.hInstance,
        nullptr);

    if (!CreateDevice(hwnd))
        return 0;

    ShowWindow(hwnd, SW_SHOWDEFAULT);
    UpdateWindow(hwnd);

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();

    ImGui_ImplWin32_Init(hwnd);
    ImGui_ImplDX11_Init(device, context);

    ImGui::StyleColorsDark();

    LoadConfig();

    std::string status = "Writes config.lua + reload.flag";

    MSG msg{};

    while (msg.message != WM_QUIT)
    {
        while (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE))
        {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }

        ImGui_ImplDX11_NewFrame();
        ImGui_ImplWin32_NewFrame();
        ImGui::NewFrame();

        ImGui::SetNextWindowSize(ImVec2(680, 500), ImGuiCond_FirstUseEver);

        ImGui::Begin("Electric Recolor Tool");

        if (ImGui::BeginTabBar("tabs"))
        {
            for (const char* tab : g_Tabs)
            {
                if (ImGui::BeginTabItem(tab))
                {
                    for (auto& fx : g_Effects)
                    {
                        if (strcmp(fx.Tab, tab) != 0)
                            continue;

                        const char* id = fx.Prefix[0] ? fx.Prefix : "Kazuya";
                        DrawEffect(id, fx.Title, *fx.Set);
                    }

                    ImGui::EndTabItem();
                }
            }

            ImGui::EndTabBar();
        }

        ImGui::Separator();

        if (ImGui::Button("Save Config", ImVec2(180, 40)))
        {
            status = SaveConfig()
                ? "Saved. Press F7 in-game to reload."
                : "Save failed - couldn't write config.lua";
        }

        ImGui::SameLine();

        if (ImGui::Button("Reload From File", ImVec2(180, 40)))
        {
            LoadConfig();
            status = "Reloaded config.lua";
        }

        ImGui::SameLine();
        ImGui::Text("%s", status.c_str());

        ImGui::End();

        ImGui::Render();

        float clear[4] = { 0.08f,0.08f,0.09f,1 };

        context->OMSetRenderTargets(1, &rtv, nullptr);
        context->ClearRenderTargetView(rtv, clear);

        ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());

        swapchain->Present(1, 0);
    }

    ImGui_ImplDX11_Shutdown();
    ImGui_ImplWin32_Shutdown();
    ImGui::DestroyContext();

    CleanupDevice();

    DestroyWindow(hwnd);
    UnregisterClass(wc.lpszClassName, wc.hInstance);

    return 0;
}

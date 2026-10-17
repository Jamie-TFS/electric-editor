local CONFIG_PATH = "Mods/Electrics/Scripts/config.lua"
local FLAG_PATH = "Mods/Electrics/reload.flag"

local config = dofile(CONFIG_PATH)

-------------------------------------------------
-- Reload
-------------------------------------------------

function ReloadConfig()
    local ok, result = pcall(function()
        return dofile(CONFIG_PATH)
    end)

    if ok then
        config = result
        print("Config reloaded")
    else
        print(result)
    end
end

local function Hex(hex, intensity)
    hex = hex:gsub("#","")

    local r = tonumber(hex:sub(1,2),16)
    local g = tonumber(hex:sub(3,4),16)
    local b = tonumber(hex:sub(5,6),16)

    return
        (r/255)*intensity,
        (g/255)*intensity,
        (b/255)*intensity,
        1.0
end

function ApplyColor(path,r,g,b,a)

    local obj = StaticFindObject(path)

    if not obj or not obj:IsValid() then
        print("Not found: "..path)
        return
    end

    local lut = obj.ShaderLUT

    if not lut then
        print("No LUT: "..path)
        return
    end

    for i=1,#lut,4 do
        lut[i]   = r
        lut[i+1] = g
        lut[i+2] = b
        lut[i+3] = a
    end
end

-------------------------------------------------
-- Apply
-------------------------------------------------

function ApplyElectric()

    -------------------------------------------------
    -- Kazuya
    -------------------------------------------------

    local kzOuterR,kzOuterG,kzOuterB,kzOuterA =
        Hex(config.OutlineColor,config.OutlineIntensity)

    local kzGlowR,kzGlowG,kzGlowB,kzGlowA =
        Hex(config.GlowColor,config.GlowIntensity)

    local kzBoltR,kzBoltG,kzBoltB,kzBoltA =
        Hex(config.MainColor,config.MainIntensity)

    -------------------------------------------------
    -- Reina CD2
    -------------------------------------------------

    local reOuterR,reOuterG,reOuterB,reOuterA =
        Hex(config.ReinaOutlineColor,config.ReinaOutlineIntensity)

    local reGlowR,reGlowG,reGlowB,reGlowA =
        Hex(config.ReinaGlowColor,config.ReinaGlowIntensity)

    local reBoltR,reBoltG,reBoltB,reBoltA =
        Hex(config.ReinaMainColor,config.ReinaMainIntensity)

    -------------------------------------------------
    -- Reina CD3
    -------------------------------------------------

    local rkOuterR,rkOuterG,rkOuterB,rkOuterA =
        Hex(config.ReinaKickOutlineColor,config.ReinaKickOutlineIntensity)

    local rkGlowR,rkGlowG,rkGlowB,rkGlowA =
        Hex(config.ReinaKickGlowColor,config.ReinaKickGlowIntensity)

    local rkBoltR,rkBoltG,rkBoltB,rkBoltA =
        Hex(config.ReinaKickMainColor,config.ReinaKickMainIntensity)

    -------------------------------------------------
    -- Heihachi EWGF
    -------------------------------------------------

    local hhOuterR,hhOuterG,hhOuterB,hhOuterA =
        Hex(config.HeihachiOutlineColor,config.HeihachiOutlineIntensity)

    local hhGlowR,hhGlowG,hhGlowB,hhGlowA =
        Hex(config.HeihachiGlowColor,config.HeihachiGlowIntensity)

    local hhBoltR,hhBoltG,hhBoltB,hhBoltA =
        Hex(config.HeihachiMainColor,config.HeihachiMainIntensity)

    -------------------------------------------------
    -- Heihachi CD1
    -------------------------------------------------

    local hcOuterR,hcOuterG,hcOuterB,hcOuterA =
        Hex(config.HeihachiCD1OutlineColor,config.HeihachiCD1OutlineIntensity)

    local hcGlowR,hcGlowG,hcGlowB,hcGlowA =
        Hex(config.HeihachiCD1GlowColor,config.HeihachiCD1GlowIntensity)

    local hcBoltR,hcBoltG,hcBoltB,hcBoltA =
        Hex(config.HeihachiCD1MainColor,config.HeihachiCD1MainIntensity)


    -------------------------------------------------
    -- Jin CD1&2
    -------------------------------------------------

    local jnOuterR,jnOuterG,jnOuterB,jnOuterA = 
    Hex(config.JinOutlineColor, config.JinOutlineIntensity)

    local jnGlowR,jnGlowG,jnGlowB,jnGlowA = 
    Hex(config.JinGlowColor, config.JinGlowIntensity)

    local jnBoltR,jnBoltG,jnBoltB,jnBoltA = 
    Hex(config.JinMainColor, config.JinMainIntensity)

    -------------------------------------------------
    -- Devil Jin
    -------------------------------------------------

    local djOuterR,djOuterG,djOuterB,djOuterA =
        Hex(config.DevilJinOutlineColor, config.DevilJinOutlineIntensity)

    local djGlowR,djGlowG,djGlowB,djGlowA =
        Hex(config.DevilJinGlowColor, config.DevilJinGlowIntensity)

    local djBoltR,djBoltG,djBoltB,djBoltA =
        Hex(config.DevilJinMainColor, config.DevilJinMainIntensity)


    -------------------------------------------------
    -- Kazuya
    -------------------------------------------------

    ApplyColor("/Game/Effect/Polariswork/Character/grl/NiagaraSystem/NS_EF_Grl_Saifu02.NS_EF_Grl_Saifu02:DynamicBeam001_3.EventScript_0.NiagaraDataInterfaceColorCurve_1",kzOuterR,kzOuterG,kzOuterB,kzOuterA)
    ApplyColor("/Game/Effect/Polariswork/Character/grl/NiagaraSystem/NS_EF_Grl_Saifu02.NS_EF_Grl_Saifu02:DynamicBeam002_11.EventScript_0.NiagaraDataInterfaceColorCurve_1",kzGlowR,kzGlowG,kzGlowB,kzGlowA)
    ApplyColor("/Game/Effect/Polariswork/Character/grl/NiagaraSystem/NS_EF_Grl_Saifu02.NS_EF_Grl_Saifu02:DynamicBeam003_4.EventScript_0.NiagaraDataInterfaceColorCurve_1",kzBoltR,kzBoltG,kzBoltB,kzBoltA)
    ApplyColor("/Game/Effect/Polariswork/Character/grl/NiagaraSystem/NS_EF_Grl_Saifu02.NS_EF_Grl_Saifu02:DynamicBeam_4.EventScript_0.NiagaraDataInterfaceColorCurve_1",kzOuterR,kzOuterG,kzOuterB,kzOuterA)

    -------------------------------------------------
    -- Reina CD2
    -------------------------------------------------

    ApplyColor("/Game/Effect/Polariswork/Character/zbr/NiagaraSystem/NS_EF_Zbr_Saifu02.NS_EF_Zbr_Saifu02:DynamicBeam001_3.EventScript_0.NiagaraDataInterfaceColorCurve_0",reOuterR,reOuterG,reOuterB,reOuterA)
    ApplyColor("/Game/Effect/Polariswork/Character/zbr/NiagaraSystem/NS_EF_Zbr_Saifu02.NS_EF_Zbr_Saifu02:DynamicBeam002_11.EventScript_0.NiagaraDataInterfaceColorCurve_0",reGlowR,reGlowG,reGlowB,reGlowA)
    ApplyColor("/Game/Effect/Polariswork/Character/zbr/NiagaraSystem/NS_EF_Zbr_Saifu02.NS_EF_Zbr_Saifu02:DynamicBeam003_4.EventScript_0.NiagaraDataInterfaceColorCurve_0",reBoltR,reBoltG,reBoltB,reBoltA)
    ApplyColor("/Game/Effect/Polariswork/Character/zbr/NiagaraSystem/NS_EF_Zbr_Saifu02.NS_EF_Zbr_Saifu02:DynamicBeam_4.EventScript_0.NiagaraDataInterfaceColorCurve_0",reOuterR,reOuterG,reOuterB,reOuterA)

    -------------------------------------------------
    -- Reina CD3
    -------------------------------------------------

    ApplyColor("/Game/Effect/Polariswork/Character/zbr/NiagaraSystem/NS_EF_Zbr_Bujinkyaku01.NS_EF_Zbr_Bujinkyaku01:DynamicBeam001_3.EventScript_0.NiagaraDataInterfaceColorCurve_0",rkOuterR,rkOuterG,rkOuterB,rkOuterA)
    ApplyColor("/Game/Effect/Polariswork/Character/zbr/NiagaraSystem/NS_EF_Zbr_Bujinkyaku01.NS_EF_Zbr_Bujinkyaku01:DynamicBeam002_11.EventScript_0.NiagaraDataInterfaceColorCurve_0",rkGlowR,rkGlowG,rkGlowB,rkGlowA)
    ApplyColor("/Game/Effect/Polariswork/Character/zbr/NiagaraSystem/NS_EF_Zbr_Bujinkyaku01.NS_EF_Zbr_Bujinkyaku01:DynamicBeam003_4.EventScript_0.NiagaraDataInterfaceColorCurve_0",rkBoltR,rkBoltG,rkBoltB,rkBoltA)
    ApplyColor("/Game/Effect/Polariswork/Character/zbr/NiagaraSystem/NS_EF_Zbr_Bujinkyaku01.NS_EF_Zbr_Bujinkyaku01:DynamicBeam_4.EventScript_0.NiagaraDataInterfaceColorCurve_0",rkOuterR,rkOuterG,rkOuterB,rkOuterA)

    -------------------------------------------------
    -- Heihachi EWGF
    -------------------------------------------------

    ApplyColor("/Game/Effect/PolarisBEEwork/Character/BEE/Niagarasystem/NS_EF_Bee_Saifu02.NS_EF_Bee_Saifu02:DynamicBeam001_3.EventScript_0.NiagaraDataInterfaceColorCurve_1",hhOuterR,hhOuterG,hhOuterB,hhOuterA)
    ApplyColor("/Game/Effect/PolarisBEEwork/Character/BEE/Niagarasystem/NS_EF_Bee_Saifu02.NS_EF_Bee_Saifu02:DynamicBeam002_11.EventScript_0.NiagaraDataInterfaceColorCurve_1",hhGlowR,hhGlowG,hhGlowB,hhGlowA)
    ApplyColor("/Game/Effect/PolarisBEEwork/Character/BEE/Niagarasystem/NS_EF_Bee_Saifu02.NS_EF_Bee_Saifu02:DynamicBeam003_4.EventScript_0.NiagaraDataInterfaceColorCurve_1",hhBoltR,hhBoltG,hhBoltB,hhBoltA)
    ApplyColor("/Game/Effect/PolarisBEEwork/Character/BEE/Niagarasystem/NS_EF_Bee_Saifu02.NS_EF_Bee_Saifu02:DynamicBeam_4.EventScript_0.NiagaraDataInterfaceColorCurve_1",hhOuterR,hhOuterG,hhOuterB,hhOuterA)

    -------------------------------------------------
    -- Heihachi CD1
    -------------------------------------------------

    ApplyColor("/Game/Effect/PolarisBEEwork/Character/BEE/Niagarasystem/NS_EF_Bee_RaijinTrail.NS_EF_Bee_RaijinTrail:DynamicBeam001_3.EventScript_0.NiagaraDataInterfaceColorCurve_14",hcOuterR,hcOuterG,hcOuterB,hcOuterA)
    ApplyColor("/Game/Effect/PolarisBEEwork/Character/BEE/Niagarasystem/NS_EF_Bee_RaijinTrail.NS_EF_Bee_RaijinTrail:DynamicBeam002_11.EventScript_0.NiagaraDataInterfaceColorCurve_8",hcGlowR,hcGlowG,hcGlowB,hcGlowA)
    ApplyColor("/Game/Effect/PolarisBEEwork/Character/BEE/Niagarasystem/NS_EF_Bee_RaijinTrail.NS_EF_Bee_RaijinTrail:DynamicBeam003_4.EventScript_0.NiagaraDataInterfaceColorCurve_8",hcBoltR,hcBoltG,hcBoltB,hcBoltA)
    ApplyColor("/Game/Effect/PolarisBEEwork/Character/BEE/Niagarasystem/NS_EF_Bee_RaijinTrail.NS_EF_Bee_RaijinTrail:DynamicBeam_4.EventScript_0.NiagaraDataInterfaceColorCurve_12",hcOuterR,hcOuterG,hcOuterB,hcOuterA)


    -------------------------------------------------
    -- Jin CD1&2
    -------------------------------------------------
    ApplyColor("/Game/Effect/Polariswork/Character/ant/NiagaraSystem/NS_EF_Ant_Saifu02.NS_EF_Ant_Saifu02:LIGHTNING_0.EventScript_0.NiagaraDataInterfaceColorCurve_0", jnOuterR,jnOuterG,jnOuterB,jnOuterA)
    ApplyColor("/Game/Effect/Polariswork/Character/ant/NiagaraSystem/NS_EF_Ant_Saifu02.NS_EF_Ant_Saifu02:Lightning001_1.EventScript_0.NiagaraDataInterfaceColorCurve_0",jnGlowR,jnGlowG,jnGlowB,jnGlowA)
    ApplyColor("/Game/Effect/Polariswork/Character/ant/NiagaraSystem/NS_EF_Ant_Saifu02.NS_EF_Ant_Saifu02:Aura_2.EventScript_0.NiagaraDataInterfaceColorCurve_0",jnBoltR,jnBoltG,jnBoltB,jnBoltA)
    ApplyColor("/Game/Effect/Polariswork/Character/ant/NiagaraSystem/NS_EF_Ant_Saifu02.NS_EF_Ant_Saifu02:Aura002_3.EventScript_0.NiagaraDataInterfaceColorCurve_0",jnOuterR,jnOuterG,jnOuterB,jnOuterA)



    -------------------------------------------------
    -- Devil Jin CD1&2
    -------------------------------------------------

    ApplyColor("/Game/Effect/Polariswork/Character/swl/NiagaraSystem/NS_EF_Swl_Saifu02.NS_EF_Swl_Saifu02:LIGHTNING_0.EventScript_0.NiagaraDataInterfaceColorCurve_0", djOuterR,djOuterG,djOuterB,djOuterA)
    ApplyColor("/Game/Effect/Polariswork/Character/swl/NiagaraSystem/NS_EF_Swl_Saifu02.NS_EF_Swl_Saifu02:Lightning001_1.EventScript_0.NiagaraDataInterfaceColorCurve_0", djGlowR,djGlowG,djGlowB,djGlowA)
    ApplyColor("/Game/Effect/Polariswork/Character/swl/NiagaraSystem/NS_EF_Swl_Saifu02.NS_EF_Swl_Saifu02:Aura_2.EventScript_0.NiagaraDataInterfaceColorCurve_0", djBoltR,djBoltG,djBoltB,djBoltA)
    ApplyColor("/Game/Effect/Polariswork/Character/swl/NiagaraSystem/NS_EF_Swl_Saifu02.NS_EF_Swl_Saifu02:Aura002_3.EventScript_0.NiagaraDataInterfaceColorCurve_0", djOuterR,djOuterG,djOuterB,djOuterA)

    print("Electric recolor applied")
end

-------------------------------------------------
-- Hooks
-------------------------------------------------

RegisterHook(
    "/Script/Polaris.PolarisCharacterActor:OnInitBattle",
    function()
        ApplyElectric()
    end
)

RegisterKeyBind(0x76,function()

    ReloadConfig()
    ApplyElectric()

    print("Reload complete")

end)

-------------------------------------------------
-- Auto reload
-------------------------------------------------

local function FlagExists()
    local f = io.open(FLAG_PATH, "r")
    if f then
        f:close()
        return true
    end
    return false
end

LoopAsync(500, function()
    if FlagExists() then
        os.remove(FLAG_PATH)

        ExecuteInGameThread(function()
            ReloadConfig()
            ApplyElectric()
            print("Auto reload complete")
        end)
    end
    return false
end)

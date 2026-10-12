using Abp.AutoMapper;
using Abp.Modules;
using Abp.Reflection.Extensions;
using GiuaKi.Authorization;

namespace GiuaKi;

[DependsOn(
    typeof(GiuaKiCoreModule),
    typeof(AbpAutoMapperModule))]
public class GiuaKiApplicationModule : AbpModule
{
    public override void PreInitialize()
    {
        Configuration.Authorization.Providers.Add<GiuaKiAuthorizationProvider>();
    }

    public override void Initialize()
    {
        var thisAssembly = typeof(GiuaKiApplicationModule).GetAssembly();

        IocManager.RegisterAssemblyByConvention(thisAssembly);

        Configuration.Modules.AbpAutoMapper().Configurators.Add(
            // Scan the assembly for classes which inherit from AutoMapper.Profile
            cfg => cfg.AddMaps(thisAssembly)
        );
    }
}

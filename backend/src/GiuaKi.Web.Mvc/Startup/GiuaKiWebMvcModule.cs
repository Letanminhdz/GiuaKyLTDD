using Abp.Modules;
using Abp.Reflection.Extensions;
using GiuaKi.Configuration;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;

namespace GiuaKi.Web.Startup;

[DependsOn(typeof(GiuaKiWebCoreModule))]
public class GiuaKiWebMvcModule : AbpModule
{
    private readonly IWebHostEnvironment _env;
    private readonly IConfigurationRoot _appConfiguration;

    public GiuaKiWebMvcModule(IWebHostEnvironment env)
    {
        _env = env;
        _appConfiguration = env.GetAppConfiguration();
    }

    public override void PreInitialize()
    {
        Configuration.Navigation.Providers.Add<GiuaKiNavigationProvider>();
    }

    public override void Initialize()
    {
        IocManager.RegisterAssemblyByConvention(typeof(GiuaKiWebMvcModule).GetAssembly());
    }
}

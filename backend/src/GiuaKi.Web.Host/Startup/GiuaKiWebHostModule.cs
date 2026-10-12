using Abp.Modules;
using Abp.Reflection.Extensions;
using GiuaKi.Configuration;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;

namespace GiuaKi.Web.Host.Startup
{
    [DependsOn(
       typeof(GiuaKiWebCoreModule))]
    public class GiuaKiWebHostModule : AbpModule
    {
        private readonly IWebHostEnvironment _env;
        private readonly IConfigurationRoot _appConfiguration;

        public GiuaKiWebHostModule(IWebHostEnvironment env)
        {
            _env = env;
            _appConfiguration = env.GetAppConfiguration();
        }

        public override void Initialize()
        {
            IocManager.RegisterAssemblyByConvention(typeof(GiuaKiWebHostModule).GetAssembly());
        }
    }
}

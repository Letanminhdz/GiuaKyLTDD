using Abp.Events.Bus;
using Abp.Modules;
using Abp.Reflection.Extensions;
using GiuaKi.Configuration;
using GiuaKi.EntityFrameworkCore;
using GiuaKi.Migrator.DependencyInjection;
using Castle.MicroKernel.Registration;
using Microsoft.Extensions.Configuration;

namespace GiuaKi.Migrator;

[DependsOn(typeof(GiuaKiEntityFrameworkModule))]
public class GiuaKiMigratorModule : AbpModule
{
    private readonly IConfigurationRoot _appConfiguration;

    public GiuaKiMigratorModule(GiuaKiEntityFrameworkModule abpProjectNameEntityFrameworkModule)
    {
        abpProjectNameEntityFrameworkModule.SkipDbSeed = true;

        _appConfiguration = AppConfigurations.Get(
            typeof(GiuaKiMigratorModule).GetAssembly().GetDirectoryPathOrNull()
        );
    }

    public override void PreInitialize()
    {
        Configuration.DefaultNameOrConnectionString = _appConfiguration.GetConnectionString(
            GiuaKiConsts.ConnectionStringName
        );

        Configuration.BackgroundJobs.IsJobExecutionEnabled = false;
        Configuration.ReplaceService(
            typeof(IEventBus),
            () => IocManager.IocContainer.Register(
                Component.For<IEventBus>().Instance(NullEventBus.Instance)
            )
        );
    }

    public override void Initialize()
    {
        IocManager.RegisterAssemblyByConvention(typeof(GiuaKiMigratorModule).GetAssembly());
        ServiceCollectionRegistrar.Register(IocManager);
    }
}

using Abp.AspNetCore;
using Abp.AspNetCore.TestBase;
using Abp.Modules;
using Abp.Reflection.Extensions;
using GiuaKi.EntityFrameworkCore;
using GiuaKi.Web.Startup;
using Microsoft.AspNetCore.Mvc.ApplicationParts;

namespace GiuaKi.Web.Tests;

[DependsOn(
    typeof(GiuaKiWebMvcModule),
    typeof(AbpAspNetCoreTestBaseModule)
)]
public class GiuaKiWebTestModule : AbpModule
{
    public GiuaKiWebTestModule(GiuaKiEntityFrameworkModule abpProjectNameEntityFrameworkModule)
    {
        abpProjectNameEntityFrameworkModule.SkipDbContextRegistration = true;
    }

    public override void PreInitialize()
    {
        Configuration.UnitOfWork.IsTransactional = false; //EF Core InMemory DB does not support transactions.
    }

    public override void Initialize()
    {
        IocManager.RegisterAssemblyByConvention(typeof(GiuaKiWebTestModule).GetAssembly());
    }

    public override void PostInitialize()
    {
        IocManager.Resolve<ApplicationPartManager>()
            .AddApplicationPartsIfNotAddedBefore(typeof(GiuaKiWebMvcModule).Assembly);
    }
}
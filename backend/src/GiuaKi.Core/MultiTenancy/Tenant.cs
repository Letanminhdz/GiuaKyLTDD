using Abp.MultiTenancy;
using GiuaKi.Authorization.Users;

namespace GiuaKi.MultiTenancy;

public class Tenant : AbpTenant<User>
{
    public Tenant()
    {
    }

    public Tenant(string tenancyName, string name)
        : base(tenancyName, name)
    {
    }
}

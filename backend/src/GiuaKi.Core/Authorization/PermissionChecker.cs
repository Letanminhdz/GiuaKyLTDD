using Abp.Authorization;
using GiuaKi.Authorization.Roles;
using GiuaKi.Authorization.Users;

namespace GiuaKi.Authorization;

public class PermissionChecker : PermissionChecker<Role, User>
{
    public PermissionChecker(UserManager userManager)
        : base(userManager)
    {
    }
}

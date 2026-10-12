using GiuaKi.Roles.Dto;
using GiuaKi.Users.Dto;
using System.Collections.Generic;
using System.Linq;

namespace GiuaKi.Web.Models.Users;

public class EditUserModalViewModel
{
    public UserDto User { get; set; }

    public IReadOnlyList<RoleDto> Roles { get; set; }

    public bool UserIsInRole(RoleDto role)
    {
        return User.RoleNames != null && User.RoleNames.Any(r => r == role.NormalizedName);
    }
}

using GiuaKi.Roles.Dto;
using System.Collections.Generic;

namespace GiuaKi.Web.Models.Users;

public class UserListViewModel
{
    public IReadOnlyList<RoleDto> Roles { get; set; }
}

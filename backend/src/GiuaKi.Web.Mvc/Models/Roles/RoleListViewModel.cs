using GiuaKi.Roles.Dto;
using System.Collections.Generic;

namespace GiuaKi.Web.Models.Roles;

public class RoleListViewModel
{
    public IReadOnlyList<PermissionDto> Permissions { get; set; }
}

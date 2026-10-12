using Abp.AutoMapper;
using GiuaKi.Sessions.Dto;

namespace GiuaKi.Web.Views.Shared.Components.TenantChange;

[AutoMapFrom(typeof(GetCurrentLoginInformationsOutput))]
public class TenantChangeViewModel
{
    public TenantLoginInfoDto Tenant { get; set; }
}

using Abp.Application.Services;
using GiuaKi.MultiTenancy.Dto;

namespace GiuaKi.MultiTenancy;

public interface ITenantAppService : IAsyncCrudAppService<TenantDto, int, PagedTenantResultRequestDto, CreateTenantDto, TenantDto>
{
}


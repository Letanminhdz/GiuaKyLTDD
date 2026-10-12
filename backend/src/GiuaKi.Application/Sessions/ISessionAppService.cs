using Abp.Application.Services;
using GiuaKi.Sessions.Dto;
using System.Threading.Tasks;

namespace GiuaKi.Sessions;

public interface ISessionAppService : IApplicationService
{
    Task<GetCurrentLoginInformationsOutput> GetCurrentLoginInformations();
}

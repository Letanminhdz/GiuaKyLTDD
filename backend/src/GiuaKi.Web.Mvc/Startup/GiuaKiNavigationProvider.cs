using Abp.Application.Navigation;
using Abp.Localization;
using GiuaKi.Authorization;

namespace GiuaKi.Web.Startup;

/// <summary>
/// Menu cho Admin hệ thống thi trắc nghiệm TOEIC
/// </summary>
public class GiuaKiNavigationProvider : NavigationProvider
{
    public override void SetNavigation(INavigationProviderContext context)
    {
        context.Manager.MainMenu
            .AddItem(
                new MenuItemDefinition(
                    "ExamManagement",
                    new FixedLocalizableString("1. Import Đề thi (.docx)"),
                    url: "Exam",
                    icon: "fas fa-cloud-upload-alt"
                )
            )
            .AddItem(
                new MenuItemDefinition(
                    "ExamReview",
                    new FixedLocalizableString("2. Rà soát & Sửa nội dung"),
                    url: "Exam",
                    icon: "fas fa-edit"
                )
            );
    }
}
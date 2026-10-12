using System.ComponentModel.DataAnnotations;

namespace GiuaKi.Users.Dto;

public class ChangeUserLanguageDto
{
    [Required]
    public string LanguageName { get; set; }
}
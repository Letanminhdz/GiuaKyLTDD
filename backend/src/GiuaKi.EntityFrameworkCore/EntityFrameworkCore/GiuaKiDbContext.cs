using Abp.Zero.EntityFrameworkCore;
using GiuaKi.Authorization.Roles;
using GiuaKi.Authorization.Users;
using GiuaKi.MultiTenancy;
using Microsoft.EntityFrameworkCore;

namespace GiuaKi.EntityFrameworkCore;

public class GiuaKiDbContext : AbpZeroDbContext<Tenant, Role, User, GiuaKiDbContext>
{
    public DbSet<Exam> Exams { get; set; }
    public DbSet<QuestionGroup> QuestionGroups { get; set; }
    public DbSet<Question> Questions { get; set; }

    public GiuaKiDbContext(DbContextOptions<GiuaKiDbContext> options)
        : base(options)
    {
    }
}
using Microsoft.EntityFrameworkCore;
using System.Data.Common;

namespace GiuaKi.EntityFrameworkCore;

public static class GiuaKiDbContextConfigurer
{
    public static void Configure(DbContextOptionsBuilder<GiuaKiDbContext> builder, string connectionString)
    {
        builder.UseSqlServer(connectionString);
    }

    public static void Configure(DbContextOptionsBuilder<GiuaKiDbContext> builder, DbConnection connection)
    {
        builder.UseSqlServer(connection);
    }
}

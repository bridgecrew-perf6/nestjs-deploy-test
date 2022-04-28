import { Test, TestingModule } from '@nestjs/testing';
import { AppModule } from 'src/app.module';
// import { PrismaService } from 'src/prisma/prisma.service';
import { UsersService } from './users.service';

describe('UsersService', () => {
  // let prisma: PrismaService;
  let userService: UsersService;
  // let userId: number;

  beforeAll(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    // prisma = module.get<PrismaService>(PrismaService);
    userService = module.get<UsersService>(UsersService);
    // await prisma.cleanDatabase();
  });

  describe('user CRUD', () => {
    it('create', async () => {
      const user = await userService.create({
        email: 'fuga@fugafuga.fugaga',
      });
      expect(user.email).toBe('fuga@fugafuga.fugaga');
      // userId = user.id;
    });

    it('create email重複', async () => {
      try {
        await userService.create({
          email: 'fuga@fugafuga.fugaga',
        });
      } catch (error) {
        expect(error.status).toBe(403);
      }
    });
  });
});

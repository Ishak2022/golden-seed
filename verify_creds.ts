
import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
    const email = 'admin@demo.local';
    const password = 'Admin123!';

    console.log(`🔍 Checking user: ${email}`);
    const user = await prisma.user.findUnique({
        where: { email }
    });

    if (!user) {
        console.error('❌ User not found in database!');
        return;
    }

    console.log(`✅ User found. Hashed password in DB: ${user.password}`);

    if (!user.password) {
        console.error('❌ User has no password set!');
        return;
    }

    const match = await bcrypt.compare(password, user.password);
    if (match) {
        console.log('✅ Password matches!');
    } else {
        console.error('❌ Password DOES NOT match!');

        // Let's try hashing it now and comparing
        const newHash = await bcrypt.hash(password, 10);
        console.log(`💡 Current check of Admin123! would result in hash: ${newHash}`);
    }
}

main()
    .catch(console.error)
    .finally(() => prisma.$disconnect());

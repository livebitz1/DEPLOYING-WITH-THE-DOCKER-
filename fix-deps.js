const { execSync } = require('child_process');

console.log('Installing and fixing dependencies...');

const dependencies = [
  'pino-pretty',
  'bs58',
  'tweetnacl',
  '@solana/buffer-layout',
  'superstruct',
  'buffer',
  'events',
  'assert',
  'crypto-browserify',
  'stream-browserify',
  'util',
  '@project-serum/borsh',
  '@solana/spl-token'
];

const devDependencies = [
  'encoding'
];

try {
  // Install production dependencies
  dependencies.forEach(dep => {
    try {
      console.log(`Installing ${dep}...`);
      execSync(`npm install ${dep} --save --legacy-peer-deps`, { stdio: 'inherit' });
    } catch (error) {
      console.warn(`Warning: Failed to install ${dep}:`, error.message);
    }
  });

  // Install dev dependencies
  devDependencies.forEach(dep => {
    try {
      console.log(`Installing dev dependency ${dep}...`);
      execSync(`npm install ${dep} --save-dev --legacy-peer-deps`, { stdio: 'inherit' });
    } catch (error) {
      console.warn(`Warning: Failed to install dev dependency ${dep}:`, error.message);
    }
  });

  // Fix potential peer dependency issues
  console.log('Fixing peer dependencies...');
  execSync('npm install --legacy-peer-deps', { stdio: 'inherit' });

  // Clean npm cache
  console.log('Cleaning npm cache...');
  execSync('npm cache clean --force', { stdio: 'inherit' });

  console.log('All dependencies installed successfully!');
} catch (error) {
  console.error('Failed to complete dependency installation:', error.message);
  process.exit(1);
}

console.log('All done! You can now run the application.');

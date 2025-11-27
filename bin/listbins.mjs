import { readdir, stat, constants } from 'node:fs/promises'

const pkgs = await readdir('node_modules')

for (const pkgName of pkgs) {
  const s = await stat(`node_modules/${pkgName}`)
  if(!s.isDirectory()) continue;

  const dirs = await readdir(`node_modules/${pkgName}`)

  if (dirs.find(v => v === 'bin')) {
    const runnables = await readdir(`node_modules/${pkgName}/bin`)
    for (const runnable of runnables) {
      const fname = `node_modules/${pkgName}/bin/${runnable}`
      const rs = await stat(fname)
      if (rs.mode & constants.S_IXUSR) {
        console.log(`${pkgName.padEnd(45, ' ')}: ${runnable}`)
      }
    }
  }
}

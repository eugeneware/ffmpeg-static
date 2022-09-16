const fs = require('fs');

(function(){
  const package = process.argv.slice(2);
  if(!package.length){ throw new Error('Package name undefined')}
  fs.copyFileSync('install.js', `./${package}/install.js`);
  fs.copyFileSync('index.js', `./${package}/index.js`);

  const binaryPackage = require(`./${package}/_package.json`);
  const templatePackage = require('./package.json');
  
  fs.writeFileSync(`./${package}/package.json`, JSON.stringify({...templatePackage, ...binaryPackage}, null, 2))
}());
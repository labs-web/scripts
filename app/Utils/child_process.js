

 
function run_commande(commande) {
  const child_process = require('child_process');
  try {
    const output = child_process.execSync(commande).toString();
    console.log(output);
  } catch (error) {
    console.error(error.toString());
  }
}

module.exports = {
    run_commande
}
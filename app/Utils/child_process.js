

function run_commande(commande){
    const child_process = require('child_process');

    child_process.exec(commande, (error, stdout, stderr) => {
      if (error) {
        console.error(error);
        return;
      }
    
      console.log(stdout);
    });
}

module.exports = {
    run_commande
}
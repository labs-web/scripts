const { spawn } = require('child_process');

const runPowershell = async (command) => {
  const child = spawn('powershell', command.split(' '));
  const output = [];

  child.stdout.on('data', (data) => {
    output.push(data.toString());
  });

  child.stderr.on('data', (data) => {
    console.error(data.toString());
  });

  await new Promise((resolve, reject) => {
    child.on('close', (code) => {
      if (code === 0) {
        resolve(output.join(''));
      } else {
        reject(new Error(`Powershell command failed: ${code}`));
      }
    });
  });
};

(async () => {
  const userName = await runPowershell('Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property UserName');
  console.log('Current user:', userName);
})();

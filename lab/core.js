// Default parameter for debug flag
let is_debug = true;  // Assuming debugging enabled by default
let is_confirm_message = true;

// Debug function
function debug(message) {
  if (is_debug) {
    console.log('\n- ' + message);
  }
}

// Confirmation function with improved formatting
function confirmToContinue(message) {
  const title = '- Run: ' + message;
  const choices = ['Yes', 'No'];

  if (is_confirm_message) { // Assuming confirm_message is a global variable
    const decision = prompt(title, choices.join(', ')); // Use prompt for Node.js (consider alternatives for browsers)
    if (decision === '1') {
      console.error('\n- You must accept to continue\n');
      process.exit(1); // Exit with non-zero code for error
    }
    console.log(); // Add newline for better formatting
  } else {
    console.log('\n' + message + '\n'); // Use console.log for messages
  }
}

// Error function
function error(message) {
  console.error('\n- ' + message + '\n'); // Use console.error for errors
  process.exit(1); // Exit with non-zero code for error
}


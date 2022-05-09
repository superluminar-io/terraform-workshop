const greetingEnabled = process.env.GREETING_ENABLED === "true";

exports.handler = async (event) => {  
  let message = "Hello from Lambda! 👋";
  const name = event.queryStringParameters?.name;

  if (greetingEnabled && name) {
    message = `Hello ${name}! 👋`;
  }

  return { message };
};

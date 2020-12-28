const response = await fetch(Deno.args[0], {
  method: 'POST',
    body: `payload=${JSON.stringify({
      username: "Deno",
      attachments: [{
        pretext: `${Deno.args[1]}`,
        title: `Build`,
        title_link: `${Deno.args[2]}`,
        color: `${Deno.args[3]}`
      }]
    })}`,
  headers: {
    'content-type': 'application/x-www-form-urlencoded'
  }
});

if (!response.ok) {
    console.log(`Fetch error: ${response.statusText}`);
}

export {}
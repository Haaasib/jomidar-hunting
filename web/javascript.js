window.addEventListener('message', function(event) {
    if (event.data.action === "show") {
        document.getElementById("hunting-ui").style.display = "block";
    } else if (event.data.action === "hide") {
        document.getElementById("hunting-ui").style.display = "none";
    }
});

function closeUI() {
    fetch(`https://${GetParentResourceName()}/closeUI`, { method: 'POST' });
}


document.addEventListener('DOMContentLoaded', function() {
    const contractButtons = document.querySelectorAll('.take-contract');
    contractButtons.forEach(button => {
        button.addEventListener('click', function() {
            const buttonId = this.id;
            fetch(`https://${GetParentResourceName()}/takeContract`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({
                    contract: buttonId
                })
            }).then(resp => resp.json()).then(resp => {
                closeUI(); // Function to close the UI
            }).catch(error => console.error('Error:', error));
        });
    });
});

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeUI();

        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
        });
    }
});
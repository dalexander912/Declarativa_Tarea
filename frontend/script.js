async function consultar() {

    const funcion = document.getElementById("funcion").value.trim();
    const a = document.getElementById("a").value.trim();
    const b = document.getElementById("b").value.trim();

    if (!funcion || !a || !b) {

        document.getElementById("primitiva").innerText =
            "Por favor ingrese todos los datos.";
        document.getElementById("area").innerText = "";

        return;
    }

    try {
        const respuesta = await fetch(
            `http://localhost:8080/consulta?funcion=${encodeURIComponent(funcion)}&a=${a}&b=${b}`
        );

        const datos = await respuesta.json();

        document.getElementById("primitiva").innerText =
            "Primitiva: " + datos.primitiva;
        document.getElementById("area").innerText =
            "Área: " + datos.area;

    } catch(e) {

        document.getElementById("primitiva").innerText =
            "Error al consultar.";
        document.getElementById("area").innerText = "";

        console.error(e);
    }
}
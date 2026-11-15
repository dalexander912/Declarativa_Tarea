const form = document.getElementById("calculadora");
const button = document.getElementById("botonConsultar");
const statusLabel = document.getElementById("estado");
const resultPanel = document.querySelector(".result-panel");

function mostrarError(message) {
    document.getElementById("error").textContent = message;
    document.getElementById("error").hidden = false;
    document.getElementById("resultado").hidden = true;
    document.getElementById("sinResultado").hidden = true;
    statusLabel.textContent = "REVISA LOS DATOS";
}

async function consultar() {
    if (button.disabled) return;
    const inputs = ["funcion", "a", "b"].map(id => document.getElementById(id));
    const [funcion, a, b] = inputs.map(input => input.value.trim());
    inputs.forEach(input => input.removeAttribute("aria-invalid"));
    document.getElementById("error").hidden = true;
    const invalid = inputs.filter((input, index) => !input.value.trim() ||
        (index > 0 && !Number.isFinite(Number(input.value))));
    if (invalid.length) {
        invalid.forEach(input => input.setAttribute("aria-invalid", "true"));
        mostrarError("Completa la función y ambos límites con valores numéricos válidos.");
        invalid[0].focus();
        return;
    }
    button.disabled = true;
    button.querySelector("span").textContent = "Calculando…";
    statusLabel.textContent = "CALCULANDO";
    resultPanel.setAttribute("aria-busy", "true");
    document.getElementById("resultado").hidden = true;
    document.getElementById("sinResultado").hidden = true;
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 15000);
    try {
        const parametros = new URLSearchParams({ funcion, a, b });
        const respuesta = await fetch(`/consulta?${parametros}`, { signal: controller.signal });
        const datos = await respuesta.json();
        if (!respuesta.ok) {
            mostrarError(datos.error || "No se pudo realizar el cálculo.");
            return;
        }
        document.getElementById("funcionResultado").textContent = funcion;
        document.getElementById("primitiva").textContent = datos.primitiva;
        document.getElementById("area").textContent = String(datos.area);
        document.getElementById("intervalo").textContent = `Entre a = ${a} y b = ${b}`;
        document.getElementById("resultado").hidden = false;
        statusLabel.textContent = "CÁLCULO COMPLETADO";
    } catch (error) {
        mostrarError(error.name === "AbortError"
            ? "El cálculo tardó demasiado. Prueba una expresión más sencilla."
            : "No se pudo conectar con el servidor. Intenta nuevamente.");
    } finally {
        clearTimeout(timeout);
        button.disabled = false;
        button.querySelector("span").textContent = "Calcular integral";
        resultPanel.setAttribute("aria-busy", "false");
    }
}

form.addEventListener("submit", event => {
    event.preventDefault();
    consultar();
});
document.querySelectorAll(".example").forEach(example => {
    example.addEventListener("click", () => {
        if (button.disabled) return;
        document.getElementById("funcion").value = example.dataset.function;
        document.getElementById("a").value = example.dataset.a;
        document.getElementById("b").value = example.dataset.b;
        consultar();
    });
});

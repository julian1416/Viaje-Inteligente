# ✈️ ViajaInteligente - Tu Asistente de Viajes con IA 🤖

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Badge"/>
  <img src="https://img.shields.io/badge/Dart-Language-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Badge"/>
  <img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase Badge"/>
  <img src="https://img.shields.io/badge/Google%20Gemini-AI-8E75B2?style=for-the-badge&logo=google&logoColor=white" alt="Gemini Badge"/>
</p>

<!-- 
  ¡IMPORTANTE! Este es el "hook" visual.
  Crea un GIF corto mostrando el flujo principal de tu app (Login -> Home -> Planificación con IA)
  y reemplaza la URL. Herramientas como ScreenToGif o Kap son excelentes para esto.
-->
<p align="center">
  <img src="URL_DE_TU_GIF_AQUI" alt="Demo de ViajaInteligente" width="300"/>
</p>

## 🚀 Sobre el Proyecto

> Una aplicación móvil integral construida con Flutter, Supabase y Google Gemini para la planificación inteligente y personalizada de viajes.

Este proyecto es una solución completa que aborda el desafío de simplificar la organización de viajes. Desde la exploración de destinos y la reserva de actividades hasta la generación de itinerarios completos mediante IA, la aplicación centraliza toda la experiencia del viajero, minimiza el estrés y maximiza la aventura a través de una interfaz limpia, moderna y reactiva.

---

## ✨ Características Principales

*   **Autenticación Robusta:** Flujo completo de registro e inicio de sesión con Supabase Auth.
*   **Generación de Itinerarios con IA:** El corazón de la app. Los usuarios describen su viaje ideal y Gemini 1.5 Flash crea un plan detallado.
*   **Exploración Dinámica:** Listas de destinos y actividades cargadas directamente desde la base de datos.
*   **Sistema de Reservas:** Funcionalidad para seleccionar fechas, viajeros y confirmar actividades, guardando la reserva en la base de datos.
*   **Persistencia de Datos:** Los viajes planificados y las reservas se asocian al perfil del usuario.
*   **Interfaz Moderna y Reactiva:** Un diseño oscuro y elegante, construido con las mejores prácticas de UI/UX en Flutter.

---

## 🛠️ Tecnologías Utilizadas

| Tecnología          | Icono | Descripción                                                                                              |
| ------------------- | :---: | -------------------------------------------------------------------------------------------------------- |
| **Flutter**         |  🐦   | Framework principal para construir la interfaz de usuario nativa y multiplataforma.                        |
| **Dart**            |  🎯   | Lenguaje de programación optimizado para UI, utilizado para desarrollar con Flutter.                     |
| **Supabase**        |  🚀   | Backend-como-Servicio (BaaS) que provee la base de datos PostgreSQL, Autenticación y APIs.               |
| **PostgreSQL**      |  🐘   | Potente base de datos relacional para almacenar toda la información de la aplicación de forma estructurada. |
| **Google Gemini**   |  ✨   | Modelo de IA de vanguardia utilizado para la generación inteligente y contextual de itinerarios de viaje.   |
| **HTTP**            |  🌐   | Paquete para realizar las llamadas a la API de Google Gemini.                                            |

---

## 📸 Capturas de Pantalla

<!-- 
  Tu tabla de capturas está perfectamente estructurada.
  Ahora está en una posición más lógica dentro del documento.
-->
<table align="center">
  <tr>
    <td align="center"><strong>1. Inicio de Sesión</strong></td>
    <td align="center"><strong>2. Creación de Cuenta</strong></td>
    <td align="center"><strong>3. Página Principal</strong></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/julian1416/Viaje-Inteligente/main/screens/Login.jpg" width="220" alt="Pantalla de Login"></td>
    <td><img src="https://raw.githubusercontent.com/julian1416/Viaje-Inteligente/main/screens/CreateCount.jpg" width="220" alt="Pantalla de Creación de Cuenta"></td>
    <td><img src="https://raw.githubusercontent.com/julian1416/Viaje-Inteligente/main/screens/HomePage.jpg" width="220" alt="Pantalla Principal"></td>
  </tr>
  <tr>
    <td align="center"><strong>4. Detalles de Actividad</strong></td>
    <td align="center"><strong>5. Planificación con IA</strong></td>
    <td align="center"><strong>6. Itinerario Generado</strong></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/julian1416/Viaje-Inteligente/main/screens/Details.jpg" width="220" alt="Detalle de Actividad"></td>
    <td><img src="https://raw.githubusercontent.com/julian1416/Viaje-Inteligente/main/screens/ItineraryAI.jpg" width="220" alt="Planificación con IA"></td>
    <td><img src="https://raw.githubusercontent.com/julian1416/Viaje-Inteligente/main/screens/DetailsTravel.jpg" width="220" alt="Detalle de Viaje"></td>
  </tr>
</table>

---

## ⚙️ Cómo Empezar

Para ejecutar este proyecto localmente, sigue estos pasos:

1.  **Clona el repositorio:**
    ```bash
    git clone https://github.com/julian1416/Viaje-Inteligente.git
    ```
2.  **Instala las dependencias de Flutter:**
    ```bash
    cd Viaje-Inteligente
    flutter pub get
    ```
3.  **Configura tus variables de entorno:**
    *   Crea un archivo llamado `.env` en la raíz del proyecto.
    *   Añade tus claves de Supabase y Google Gemini:
      ```
      SUPABASE_URL=TU_URL_DE_SUPABASE
      SUPABASE_ANON_KEY=TU_ANON_KEY_DE_SUPABASE
      GEMINI_API_KEY=TU_API_KEY_DE_GEMINI
      ```
4.  **Ejecuta la aplicación:**
    ```bash
    flutter run
    ```

---

## 📬 Contacto

Desarrollado por **Julián David Rojas Román**.

- **GitHub:** [@julian1416](https://github.com/julian1416)
- **LinkedIn:** [Julián Rojas](https://www.linkedin.com/in/julian-rojas-8b4b682b0/)

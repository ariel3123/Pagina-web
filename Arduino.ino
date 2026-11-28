// ==========================================
// POLLI SMART - DISPENSADOR DE AGUA
// ESP32 + 2 FLOTADORES + RELE
// ==========================================

const int FLOTADOR_BAJO = 27;
const int FLOTADOR_ALTO = 26;
const int RELE = 25;

const int RELE_ON = LOW;
const int RELE_OFF = HIGH;

bool llenando = false;

void setup() {
  Serial.begin(115200);

  pinMode(FLOTADOR_BAJO, INPUT_PULLUP);
  pinMode(FLOTADOR_ALTO, INPUT_PULLUP);

  pinMode(RELE, OUTPUT);
  digitalWrite(RELE, RELE_OFF);

  Serial.println("POLLI SMART - DISPENSADOR DE AGUA");
  Serial.println("Sistema iniciado");
}

void loop() {
  bool bajo = digitalRead(FLOTADOR_BAJO) == LOW;
  bool alto = digitalRead(FLOTADOR_ALTO) == LOW;

  Serial.print("Flotador bajo: ");
  Serial.print(bajo ? "ACTIVADO" : "LIBRE");

  Serial.print(" | Flotador alto: ");
  Serial.println(alto ? "ACTIVADO" : "LIBRE");

  if (bajo && alto) {
    llenando = false;
    digitalWrite(RELE, RELE_OFF);
    Serial.println("ERROR: revisar flotadores");
  } else {
    if (bajo) {
      llenando = true;
    }

    if (alto) {
      llenando = false;
    }

    if (llenando) {
      digitalWrite(RELE, RELE_ON);
      Serial.println("SOLICITUD DE LLENADO");
    } else {
      digitalWrite(RELE, RELE_OFF);
      Serial.println("BOMBA APAGADA");
    }
  }

  if (bajo) {
    Serial.println("¡Nivel de agua bajo, rellenar depósito!");
  }

  Serial.println("-----------------------------");
  delay(1000);
}

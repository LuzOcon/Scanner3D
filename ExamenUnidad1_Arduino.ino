const int pots[] = {A0, A1, A2};
float giros[3] = {0};
float grados[3] = {0};

void setup() {
  Serial.begin(9600);
}

void loop() {
  for (int i = 0; i < 3; i++) {
    giros[i] = analogRead(pots[i]) * 100.0 / 1023.0;
    grados[i] = map(giros[i], 0, 100, 0, 290);
  }
  

  // Enviar los datos con el formato correcto
  Serial.print(grados[0]);
  Serial.print(',');
  Serial.print(grados[1]);
  Serial.print(',');
  Serial.print(grados[2]);
  Serial.println();  //FIN
delay(50);

}
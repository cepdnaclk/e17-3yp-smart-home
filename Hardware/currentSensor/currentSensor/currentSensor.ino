int pino_sensor = 15;
int menor_valor;
int valor_lido;
int menor_valor_acumulado = 0;
int ZERO_SENSOR = 0;
float corrente_pico;

float corrente_eficaz;
double maior_valor=0;
double corrente_valor=0;

void setup() {
  Serial.begin(9600);
  pinMode(pino_sensor,INPUT);
delay(3000);
 //Fazer o AUTO-ZERO do sensor
Serial.println("Fazendo o Auto ZERO do Sensor...");
 /*
 ZERO_SENSOR = analogRead(pino_sensor); 
 for(int i = 0; i < 10000 ; i++){
 valor_lido = analogRead(pino_sensor); 
 ZERO_SENSOR = (ZERO_SENSOR +  valor_lido)/2; 
 delayMicroseconds(1);  
 }
 Serial.print("Zero do Sensor:");
 Serial.println(ZERO_SENSOR);
 delay(3000);

 */
menor_valor = 4095;
 
  for(int i = 0; i < 10000 ; i++){
  valor_lido = analogRead(pino_sensor);
  if(valor_lido < menor_valor){
  menor_valor = valor_lido;    
  }
  delayMicroseconds(1);  
  }
  ZERO_SENSOR = menor_valor;
  Serial.print("Zero do Sensor:");
  Serial.println(ZERO_SENSOR);
  delay(3000);

 
 }

 
void loop() {

  //Zerar valores
  menor_valor = 4095;
 
  for(int i = 0; i < 1600 ; i++){
  valor_lido = analogRead(pino_sensor);
  if(valor_lido < menor_valor){
  menor_valor = valor_lido;    
  }
  delayMicroseconds(10);  
  }

  
  Serial.print("Menor Valor:");
  Serial.println(menor_valor);

  //Transformar o maior valor em corrente de pico
  corrente_pico = ZERO_SENSOR - menor_valor; // Como o ZERO do sensor é 2,5 V, é preciso remover este OFFSET. Na leitura Analógica do ESp32 com este sensor, vale 2800 (igual a 2,5 V).
  corrente_pico = corrente_pico*0.805; // A resolução mínima de leitura para o ESp32 é de 0.8 mV por divisão. Isso transforma a leitura analógica em valor de tensão em [mV}
  corrente_pico = corrente_pico/185;   // COnverter o valor de tensão para corrente de acordo com o modelo do sensor. No meu caso, esta sensibilidade vale 185mV/A
                                      // O modelo dele é ACS712-05B. Logo, precisamos dividir o valor encontrado por 185 para realizar esta conversão                                       
  
  Serial.print("Peak Current:");
  Serial.print(corrente_pico);
  Serial.print(" A");
  Serial.print(" --- ");
  Serial.print(corrente_pico*1000);
  Serial.println(" mA");
  
 
  //Converter para corrente eficaz  
  corrente_eficaz = corrente_pico/1.4;
  Serial.print("Effective Current:");
  Serial.print(corrente_eficaz);
  Serial.print(" A");
  Serial.print(" --- ");
  Serial.print(corrente_eficaz*1000);
  Serial.println(" mA");
 
 delay(5000);
}

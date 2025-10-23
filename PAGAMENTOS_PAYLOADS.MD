# Payload e Passos para pagamento por M-pesa e Paystack Tsevele

```markdown
## Fluxo Completo de Pagamento Por mpesa

```
┌─────────────────┐
│ 1. Escolher     │
│    Plano        │
└────────┬────────┘
         │
         v
┌─────────────────┐
│ 2. Criar        │
│    Depósito     │ POST /api/subscriptions/subscribe
└────────┬────────┘
         │
         v
┌─────────────────┐
│ 3. Iniciar      │
│    Pagamento    │ POST /api/payments/process-mpesa/{depositId}
│    M-Pesa       │ Body: {"phone_number": "841234567"}
└────────┬────────┘
         │
         v
┌─────────────────┐
│ 4. Usuário      │
│    Confirma no  │ (No celular do usuário)
│    Celular      │
└────────┬────────┘
         │
         v
┌─────────────────┐
│ 5. Subscrição   │
│    Ativada!     │
└─────────────────┘
```

```markdown
Parâmetros:
- `plan_type` (integer, required): ID do plano de subscrição
  - 1 = Semanal (7 dias)
  - 2 = Mensal (30 dias)
  - 3 = Trimestral (91 dias)
  - 4 = Semestral (182 dias)
  - 5 = Anual (365 dias)
- `payment_method_code` (integer, required): Código do método de pagamento (1000 para M-Pesa)
- `currency` (string, required): Moeda (MZN)
```

```markdown
### 2. Teste 1: Criar Subscrição

**Request:**
```
POST {{baseUrl}}/subscriptions/subscribe
Headers:
  Authorization: Bearer {{token}}
  Content-Type: application/json

Body (JSON):
{
  "payment_method_code": 1000,
  "plan_type": 2,
  "method_code":258,
  "currency": "MZN"
}
**Resposta Esperada (201):**
```json
{
  "status": "success",
  "data": {
    "deposit": {
      "id": 123,
      "transaction_id": "TRX7HGFD89KL",
      "amount": 150.00,
      "status": 0,
      "plan_name": "Plano Mensal"
    }
  }
}
```

✍️ **Anote o `deposit.id` para os próximos testes!**

### 3. Teste 2: Iniciar Pagamento M-Pesa

**Request:**
```
POST {{baseUrl}}/payments/process-mpesa/123
Headers:
  Authorization: Bearer {{token}}
  Content-Type: application/json

Body (JSON):
{
  "phone_number": "841234567"
}
```
**Resposta - Completado:**
```json
{
  "status": "success",
  "data": {
    "deposit_id": 279,
    "transaction_id": "Z2QETW5F21ER",
    "amount": "185.00000000",
    "final_amount": "185.00000000",
    "mpesa_reference": "HnN31761116653",
    "status": "completed"
  },
  "message": "M-Pesa payment processed successfully"
}
```

**Para PayStack**

```markdown
✅ Completamente Implementado

#### 1. **Endpoints de Subscrição**
- ✅ `GET /api/subscriptions/plans` - Listar todos os planos
- ✅ `GET /api/subscriptions/payment-methods` - Listar métodos de pagamento
- ✅ `GET /api/subscriptions/status` - Verificar status da subscrição do usuário
- ✅ `POST /api/subscriptions/subscribe` - Criar subscrição (iniciar pagamento)
- ✅ `POST /api/subscriptions/calculate-payment` - Calcular valores de pagamento
- ✅ `GET /api/subscriptions/history` - Histórico de subscrições

### 2. **Endpoints de Pagamento**
- ✅ `GET /api/payments/gateway-data/{depositId}` - Obter dados do gateway
- ✅ `POST /api/payments/verify-paystack/{reference}` - Verificar pagamento Paystack
- ✅ `GET /api/payments/history` - Histórico de pagamentos
- ✅ `GET /api/payments/status/{transactionId}` - Status de pagamento específico

## 🔄 Fluxo de Pagamento Implementado

### 1. Cliente Lista Planos
```
GET /api/subscriptions/plans
→ Retorna: Lista de 5 planos com preços e durações
```

### 2. Cliente Cria Subscrição
```
POST /api/subscriptions/subscribe
Body: { plan_type, method_code, currency }
→ Cria depósito pendente
→ Retorna: deposit_id, transaction_id, gateway_data
```

### 3. Cliente Processa Pagamento (Frontend)
```
Paystack Inline/Popup
→ Cliente insere dados do cartão
→ Paystack processa pagamento
→ Retorna: reference (transaction_id)
```

### 4. Cliente Verifica Pagamento
```
POST /api/payments/verify-paystack/{reference}
→ API consulta Paystack
→ Valida pagamento
→ Cria subscrição
→ Retorna: status de confirmação

Vou explicar o processo completo de pagamento de subscrição via Paystack API, passo a passo, com todos os payloads necessários.

## 🔄 Processo Completo de Pagamento Paystack

### **Passo 1: Autenticação do Usuário**

**Endpoint:** `POST /api/auth/login`

**Payload:**
```json
{
    "username": "seu_usuario",
    "password": "sua_senha"
}
```

**Resposta:**
```json
{
    "status": "success",
    "data": {
        "user": {
            "id": 1,
            "username": "seu_usuario",
            "email": "user@example.com"
        },
        "access_token": "1|abcd1234efgh5678...",
        "token_type": "Bearer"
    },
    "message": "Login successful"
}
```

**⚠️ Importante:** Guarde o `access_token` - será usado em todas as próximas requisições.

---

### **Passo 2: Listar Planos Disponíveis**

**Endpoint:** `GET /api/subscriptions/plans`

**Headers:** Não requer autenticação (público)

**Resposta:**
```json
{
    "status": "success",
    "data": [
        {
            "id": 1,
            "type": "weekly",
            "name": "Plano Semanal",
            "price": 50,
            "duration_days": 7,
            "description": "Acesso completo por 1 semana"
        },
        {
            "id": 2,
            "type": "monthly",
            "name": "Plano Mensal",
            "price": 150,
            "duration_days": 30,
            "description": "Acesso completo por 1 mês"
        },
        {
            "id": 3,
            "type": "quarterly",
            "name": "Plano Trimestral",
            "price": 400,
            "duration_days": 91,
            "description": "Acesso completo por 3 meses"
        }
    ],
    "message": "Subscription plans retrieved successfully"
}
```

---

### **Passo 3: Verificar Métodos de Pagamento**

**Endpoint:** `GET /api/subscriptions/payment-methods`

**Headers:** Não requer autenticação

**Resposta:**
```json
{
    "status": "success",
    "data": [
        {
            "method_code": 107,
            "method_name": "Paystack",
            "currency": "MZN",
            "symbol": "MT",
            "min_amount": 100,
            "max_amount": 1000000,
            "fixed_charge": 0,
            "percent_charge": 2.5,
            "rate": 1,
            "image": "https://seu-dominio.com/assets/images/gateway/paystack.png"
        }
    ],
    "message": "Payment methods retrieved successfully"
}
```

**📝 Nota:** O `method_code: 107` é para Paystack. Use esse código no próximo passo.

---

### **Passo 4: Criar Subscrição (Iniciar Pagamento)**

**Endpoint:** `POST /api/subscriptions/subscribe`

**Headers:**
```
Authorization: Bearer {seu_access_token}
Content-Type: application/json
```

**Payload:**
```json
{
    "plan_type": 2,
    "method_code": 107,
    "currency": "MZN"
}
```

**Descrição dos Campos:**
- `plan_type`: ID do plano (1=semanal, 2=mensal, 3=trimestral, 4=semestral, 5=anual)
- `method_code`: 107 (código do Paystack)
- `currency`: "MZN" (Metical Moçambicano)

**Resposta:**
```json
{
    "status": "success",
    "data": {
        "deposit_id": 456,
        "transaction_id": "TRX789ABC123",
        "plan_details": {
            "id": 2,
            "type": "monthly",
            "name": "Plano Mensal",
            "price": 150,
            "duration_days": 30
        },
        "payment_details": {
            "amount": 150,
            "charge": 3.75,
            "payable": 153.75,
            "final_amount": 153.75,
            "currency": "MZN",
            "method_name": "Paystack"
        },
        "gateway_data": {
            "gateway_type": "paystack",
            "public_key": "pk_test_xxxxxxxxxxxxxx",
            "amount": 15375,
            "currency": "MZN",
            "email": "user@example.com",
            "reference": "TRX789ABC123",
            "callback_url": "https://seu-dominio.com/api/payments/verify-paystack/TRX789ABC123"
        }
    },
    "message": "Subscription created successfully. Please complete payment."
}
```

**⚠️ Importante:** 
- Guarde o `transaction_id` (também chamado de `reference`)
- O `amount` em `gateway_data` está em **centavos/kobo** (multiplicado por 100)
- Use os dados de `gateway_data` no próximo passo

---

### **Passo 5: Processar Pagamento no Paystack (Frontend)**

Agora você precisa integrar o Paystack Inline no seu frontend (web ou mobile).

#### **Opção A: Web (JavaScript)**

```html
<!DOCTYPE html>
<html>
<head>
    <script src="https://js.paystack.co/v1/inline.js"></script>
</head>
<body>
    <button onclick="payWithPaystack()">Pagar com Paystack</button>

    <script>
        function payWithPaystack() {
            // Dados recebidos do Passo 4
            const gatewayData = {
                public_key: "pk_test_xxxxxxxxxxxxxx",
                amount: 15375, // em kobo (centavos)
                currency: "MZN",
                email: "user@example.com",
                reference: "TRX789ABC123"
            };

            const handler = PaystackPop.setup({
                key: gatewayData.public_key,
                email: gatewayData.email,
                amount: gatewayData.amount,
                currency: gatewayData.currency,
                ref: gatewayData.reference,
                
                callback: function(response) {
                    // Pagamento bem-sucedido
                    console.log('Payment successful! Reference: ' + response.reference);
                    
                    // Chamar API para verificar pagamento (Passo 6)
                    verifyPayment(response.reference);
                },
                
                onClose: function() {
                    // Usuário fechou o popup
                    alert('Pagamento cancelado');
                }
            });
            
            handler.openIframe();
        }

        function verifyPayment(reference) {
            fetch(`https://seu-dominio.com/api/payments/verify-paystack/${reference}`, {
                method: 'POST',
                headers: {
                    'Authorization': 'Bearer {seu_access_token}',
                    'Content-Type': 'application/json'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    alert('Subscrição ativada com sucesso!');
                    // Redirecionar para dashboard
                    window.location.href = '/dashboard';
                }
            })
            .catch(error => console.error('Error:', error));
        }
    </script>
</body>
</html>
```

#### **Opção B: Mobile (Flutter/Dart)**

```dart
import 'package:flutter_paystack/flutter_paystack.dart';

Future<void> payWithPaystack() async {
  final plugin = PaystackPlugin();
  await plugin.initialize(publicKey: 'pk_test_xxxxxxxxxxxxxx');

  Charge charge = Charge()
    ..amount = 15375 // em kobo
    ..reference = 'TRX789ABC123'
    ..email = 'user@example.com'
    ..currency = 'MZN';

  CheckoutResponse response = await plugin.checkout(
    context,
    method: CheckoutMethod.card,
    charge: charge,
  );

  if (response.status == true) {
    // Verificar pagamento (Passo 6)
    verifyPayment(response.reference);
  }
}
```

#### **Opção C: Mobile (React Native)**

```javascript
import Paystack from 'react-native-paystack';

Paystack.setPublicKey('pk_test_xxxxxxxxxxxxxx');

const payWithPaystack = async () => {
  try {
    const response = await Paystack.chargeCard({
      cardNumber: '4084084084084081',
      expiryMonth: '12',
      expiryYear: '26',
      cvc: '408',
      email: 'user@example.com',
      amountInKobo: 15375,
      currency: 'MZN',
      reference: 'TRX789ABC123'
    });

    if (response.status === 'success') {
      // Verificar pagamento (Passo 6)
      verifyPayment(response.reference);
    }
  } catch (error) {
    console.error(error);
  }
};
```

**📝 Cartões de Teste:**
```
Cartão de Sucesso:
Número: 5060666666666666666
CVV: 123
Exp: 12/26
PIN: 1234
OTP: 123456

Cartão Visa:
Número: 4084084084084081
CVV: 408
Exp: 12/26
PIN: 0000
OTP: 123456
```

---

### **Passo 6: Verificar Pagamento**

Após o cliente completar o pagamento no Paystack, você DEVE verificar o pagamento na sua API.

**Endpoint:** `POST /api/payments/verify-paystack/{reference}`

**Headers:**
```
Authorization: Bearer {seu_access_token}
Content-Type: application/json
```

**URL Exemplo:**
```
POST /api/payments/verify-paystack/TRX789ABC123
```

**Payload:** Não requer body (vazio)

**Resposta de Sucesso:**
```json
{
    "status": "success",
    "data": {
        "deposit_id": 456,
        "transaction_id": "TRX789ABC123",
        "amount": 150,
        "final_amount": 153.75,
        "paystack_reference": "TRX789ABC123",
        "status": "completed",
        "subscription": {
            "id": 123,
            "plan_type": 2,
            "plan_name": "Plano Mensal",
            "expire_date": "2025-11-22 10:30:00",
            "days_remaining": 30
        }
    },
    "message": "Paystack payment verified successfully"
}
```

**Resposta de Erro (Pagamento Não Encontrado):**
```json
{
    "status": "error",
    "message": "Deposit not found or already processed"
}
```

---

### **Passo 7: Confirmar Subscrição Ativa**

**Endpoint:** `GET /api/subscriptions/status`

**Headers:**
```
Authorization: Bearer {seu_access_token}
```

**Resposta:**
```json
{
    "status": "success",
    "data": {
        "has_active_subscription": true,
        "subscription": {
            "id": 123,
            "plan_type": 2,
            "plan_name": "Plano Mensal",
            "plan_price": 150,
            "expire_date": "2025-11-22 10:30:00",
            "days_remaining": 30,
            "created_at": "2025-10-22 10:30:00",
            "plan_details": {
                "name": "Plano Mensal",
                "price": 150,
                "duration_days": 30
            }
        }
    },
    "message": "Active subscription found"
}
```

---

## 🔄 Fluxo Alternativo: Webhook (Processamento Automático)

O Paystack também pode enviar notificações automáticas (webhooks) quando um pagamento é confirmado.

**Endpoint do Webhook:** `POST /ipn/paystack`

**⚠️ Este endpoint é chamado automaticamente pelo Paystack, não pelo seu frontend!**

**Payload Recebido do Paystack:**
```json
{
    "event": "charge.success",
    "data": {
        "id": 987654321,
        "status": "success",
        "reference": "TRX789ABC123",
        "amount": 15375,
        "currency": "MZN",
        "gateway_response": "Successful",
        "paid_at": "2025-10-22T10:32:00.000Z",
        "customer": {
            "email": "user@example.com"
        }
    }
}
```

O sistema processa automaticamente esse webhook e:
1. ✅ Atualiza o status do depósito para `completed`
2. ✅ Cria a subscrição
3. ✅ Atualiza o saldo do usuário
4. ✅ Envia notificação

**Configurar no Paystack Dashboard:**
1. Acesse: https://dashboard.paystack.com/#/settings/developer
2. Vá em **Webhooks**
3. Adicione: `https://seu-dominio.com/ipn/paystack`
4. Ative: `charge.success`

---

## 📊 Resumo do Fluxo Completo

```
1. Login → Recebe access_token
   ↓
2. GET /api/subscriptions/plans → Escolhe plano
   ↓
3. POST /api/subscriptions/subscribe
   Body: {"plan_type":2,"method_code":107,"currency":"MZN"}
   Recebe: transaction_id e gateway_data
   ↓
4. Frontend → Paystack.inline({...gateway_data})
   Cliente paga com cartão
   ↓
5. POST /api/payments/verify-paystack/{transaction_id}
   Sistema verifica com Paystack API
   ↓
6. GET /api/subscriptions/status → Confirma subscrição ativa
```

---

## 🧪 Teste Completo com cURL

```bash
# 1. Login
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"password123"}'

# Copie o access_token da resposta
TOKEN="1|abcd1234..."

# 2. Listar planos
curl http://localhost:8000/api/subscriptions/plans

# 3. Criar subscrição
curl -X POST http://localhost:8000/api/subscriptions/subscribe \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"plan_type":2,"method_code":107,"currency":"MZN"}'

# Copie o transaction_id da resposta
TRX_ID="TRX789ABC123"

# 4. Simular pagamento (pular - feito no frontend com Paystack)

# 5. Verificar pagamento
curl -X POST http://localhost:8000/api/payments/verify-paystack/$TRX_ID \
  -H "Authorization: Bearer $TOKEN"

# 6. Confirmar subscrição
curl http://localhost:8000/api/subscriptions/status \
  -H "Authorization: Bearer $TOKEN"
```

```

# 📋 PAYLOADS DO PAYSTACK - GUIA COMPLETO

## 🔵 1. CRIAR SUBSCRIÇÃO (Subscribe)

**Endpoint:** `POST /api/subscriptions/subscribe`

**Headers:**

```json
{
  "Authorization": "Bearer {seu_token_jwt}",
  "Content-Type": "application/json",
  "Accept": "application/json"
}

```

**Request Payload:**

```json
{
  "plan_type": 2,
  "gateway_code": 521
}

```

**Response Success (200):**

```json
{
  "status": "success",
  "data": {
    "deposit_id": 145,
    "transaction_id": "ABC123XYZ789",
    "plan_name": "Plano Mensal",
    "plan_price": 1500,
    "amount": 1500,
    "charge": 22.5,
    "final_amount": 1522.5,
    "method_code": 521,
    "method_currency": "MZN",
    "gateway_data": {
      "public_key": "pk_test_xxxxxxxxxxxxx",
      "amount": 152250,
      "currency": "MZN",
      "reference": "ABC123XYZ789",
      "email": "user@example.com",
      "callback_url": "<https://seusite.com/api/payments/verify-paystack/ABC123XYZ789>"
    }
  },
  "message": "Subscription created successfully"
}

```

---

## 🔵 2. PROCESSAR PAGAMENTO NO PAYSTACK (Flutter)

**Dados recebidos do backend:**

```dart
// Do response anterior
final publicKey = response['data']['gateway_data']['public_key'];
final amount = response['data']['gateway_data']['amount']; // em kobo/centavos
final reference = response['data']['gateway_data']['reference'];
final email = response['data']['gateway_data']['email'];
final currency = response['data']['gateway_data']['currency'];

```

**Charge Object (Flutter Paystack):**

```dart
Charge charge = Charge()
  ..amount = 152250 // Valor em kobo (1522.50 MZN = 152250 centavos)
  ..reference = "ABC123XYZ789"
  ..email = "user@example.com"
  ..currency = "MZN";

```

---

## 🔵 3. VERIFICAR PAGAMENTO (Backend API)

**Endpoint:** `GET /api/payments/verify-paystack/{reference}`

**Headers:**

```json
{
  "Authorization": "Bearer {seu_token_jwt}",
  "Accept": "application/json"
}

```

**URL Example:**

```
GET /api/payments/verify-paystack/ABC123XYZ789

```

**Response Success (200):**

```json
{
  "status": "success",
  "data": {
    "payment_verified": true,
    "subscription": {
      "id": 87,
      "user_id": 42,
      "plan_type": 2,
      "plan_name": "Plano Mensal",
      "price": 1500,
      "expire_date": "2025-11-22 14:30:00",
      "days_remaining": 30,
      "created_at": "2025-10-22 14:30:00"
    },
    "deposit": {
      "id": 145,
      "transaction_id": "ABC123XYZ789",
      "amount": 1500,
      "charge": 22.5,
      "final_amount": 1522.5,
      "status": 1,
      "status_text": "Completed"
    }
  },
  "message": "Payment verified and subscription activated successfully"
}

```

**Response Failed (400):**

```json
{
  "status": "error",
  "message": "Payment verification failed",
  "error": "Transaction not found or payment not completed"
}

```

---

## 🔵 4. VERIFICAÇÃO DIRETA NO PAYSTACK (Server to Server)

**Endpoint Paystack:** `GET <https://api.paystack.co/transaction/verify/{reference}`>

**Headers:**

```json
{
  "Authorization": "Bearer sk_test_xxxxxxxxxxxxxxxxxx",
  "Content-Type": "application/json"
}

```

**Response do Paystack:**

```json
{
  "status": true,
  "message": "Verification successful",
  "data": {
    "id": 987654321,
    "domain": "test",
    "status": "success",
    "reference": "ABC123XYZ789",
    "amount": 152250,
    "message": null,
    "gateway_response": "Successful",
    "paid_at": "2025-10-22T14:30:15.000Z",
    "created_at": "2025-10-22T14:28:30.000Z",
    "channel": "card",
    "currency": "MZN",
    "ip_address": "102.89.23.45",
    "metadata": "",
    "log": {
      "start_time": 1729605510,
      "time_spent": 5,
      "attempts": 1,
      "errors": 0,
      "success": true,
      "mobile": false,
      "input": [],
      "history": [
        {
          "type": "action",
          "message": "Attempted to pay with card",
          "time": 2
        },
        {
          "type": "success",
          "message": "Successfully paid with card",
          "time": 5
        }
      ]
    },
    "fees": 2284,
    "fees_split": null,
    "authorization": {
      "authorization_code": "AUTH_pmx3mgawyd",
      "bin": "408408",
      "last4": "4081",
      "exp_month": "12",
      "exp_year": "2030",
      "channel": "card",
      "card_type": "visa ",
      "bank": "TEST BANK",
      "country_code": "NG",
      "brand": "visa",
      "reusable": true,
      "signature": "SIG_xxxxxxxxxxxxx",
      "account_name": null
    },
    "customer": {
      "id": 12345678,
      "first_name": null,
      "last_name": null,
      "email": "user@example.com",
      "customer_code": "CUS_xxxxxxxxxx",
      "phone": null,
      "metadata": null,
      "risk_action": "default",
      "international_format_phone": null
    },
    "plan": null,
    "split": {},
    "order_id": null,
    "paidAt": "2025-10-22T14:30:15.000Z",
    "createdAt": "2025-10-22T14:28:30.000Z",
    "requested_amount": 152250,
    "pos_transaction_data": null,
    "source": null,
    "fees_breakdown": null,
    "transaction_date": "2025-10-22T14:28:30.000Z",
    "plan_object": {},
    "subaccount": {}
  }
}

```

---

## 🔵 5. WEBHOOK DO PAYSTACK

**Endpoint:** `POST /ipn/paystack`

**Headers:**

```json
{
  "Content-Type": "application/json",
  "x-paystack-signature": "computed_hash_signature"
}

```

**Webhook Payload:**

```json
{
  "event": "charge.success",
  "data": {
    "id": 987654321,
    "domain": "test",
    "status": "success",
    "reference": "ABC123XYZ789",
    "amount": 152250,
    "message": null,
    "gateway_response": "Successful",
    "paid_at": "2025-10-22T14:30:15.000Z",
    "created_at": "2025-10-22T14:28:30.000Z",
    "channel": "card",
    "currency": "MZN",
    "ip_address": "102.89.23.45",
    "metadata": {
      "custom_fields": []
    },
    "fees": 2284,
    "customer": {
      "id": 12345678,
      "email": "user@example.com",
      "customer_code": "CUS_xxxxxxxxxx"
    },
    "authorization": {
      "authorization_code": "AUTH_pmx3mgawyd",
      "bin": "408408",
      "last4": "4081",
      "exp_month": "12",
      "exp_year": "2030",
      "channel": "card",
      "card_type": "visa"
    }
  }
}

```

---

## 🔵 6. HISTÓRICO DE PAGAMENTOS

**Endpoint:** `GET /api/payments/history?limit=15&page=1&status=1`

**Response:**

```json
{
  "status": "success",
  "data": [
    {
      "id": 145,
      "transaction_id": "ABC123XYZ789",
      "amount": 1500,
      "charge": 22.5,
      "final_amount": 1522.5,
      "method_code": 521,
      "method_currency": "MZN",
      "status": 1,
      "status_text": "Completed",
      "plan_type": 2,
      "plan_name": "Plano Mensal",
      "plan_price": 1500,
      "gateway": {
        "name": "Paystack",
        "image": "<https://seusite.com/assets/images/gateway/paystack.png>"
      },
      "created_at": "2025-10-22 14:30:00",
      "updated_at": "2025-10-22 14:31:00"
    }
  ],
  "pagination": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 15,
    "total": 67
  },
  "message": "Payment history retrieved successfully"
}

```

---

## 📌 RESUMO DOS VALORES

| Campo | Exemplo | Descrição |
| --- | --- | --- |
| `plan_price` | 1500 | Preço base do plano em MZN |
| `charge` | 22.5 | Taxa de processamento (1.5%) |
| `final_amount` | 1522.5 | Total a pagar em MZN |
| `amount` (Paystack) | 152250 | Valor em **kobo/centavos** (× 100) |

**Conversão:** `1522.5 MZN × 100 = 152250 centavos`
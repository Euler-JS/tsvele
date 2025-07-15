import 'package:flutter/material.dart';

class SubscriptionPlansPage extends StatefulWidget {
  const SubscriptionPlansPage({super.key});

  @override
  State<SubscriptionPlansPage> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage> {
  int selectedPlan = 1; // Plano mensal como padrão
  int selectedPaymentMethod = 0; // 0 = Mpesa, 1 = Cartão

  final List<Map<String, dynamic>> plans = [
    {
      'title': 'Subscrição Semanal',
      'price': 'MZN 50.00',
      'period': '/semana',
      'duration': '1 semana',
      'popular': false,
    },
    {
      'title': 'Subscrição Mensal',
      'price': 'MZN 185.00',
      'period': '/mês',
      'duration': '1 mês',
      'popular': true,
    },
    {
      'title': 'Subscrição Trimestral',
      'price': 'MZN 475.00',
      'period': '/3 meses',
      'duration': '3 meses',
      'savings': 'Economize 14%',
      'popular': false,
    },
    {
      'title': 'Subscrição Semestral',
      'price': 'MZN 918.00',
      'period': '/6 meses',
      'duration': '6 meses',
      'savings': 'Economize 17%',
      'popular': false,
    },
    {
      'title': 'Subscrição Anual',
      'price': 'MZN 1,792.00',
      'period': '/ano',
      'duration': '1 ano',
      'savings': 'Economize 19%',
      'popular': false,
    },
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'M-Pesa',
      'icon': Icons.phone_android,
      'description': 'Pague com seu telefone',
      'color': Color(0xFF1E88E5),
    },
    {
      'name': 'Cartão',
      'icon': Icons.credit_card,
      'description': 'Visa/Mastercard',
      'color': Color(0xFF1976D2),
    },
  ];

  final List<String> benefits = [
    'Acesso ilimitado a todas as notícias premium',
    'Conteúdo exclusivo dos melhores jornalistas moçambicanos',
    'Notícias locais e internacionais em tempo real',
    'Leitura offline - baixe e leia sem internet',
    'Experiência sem anúncios publicitários',
    'Newsletter semanal com resumo das principais notícias',
    'Acesso antecipado a novos recursos e seções',
    'Suporte prioritário via WhatsApp e email',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF333333),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Planos Premium',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              buildHeader(),
              
              const SizedBox(height: 30),
              
              // Planos
              buildPlansSection(),
              
              const SizedBox(height: 30),
              
              // Métodos de pagamento
              buildPaymentMethodsSection(),
              
              const SizedBox(height: 30),
              
              // Benefícios
              buildBenefitsSection(),
              
              const SizedBox(height: 30),
              
              // Botão de assinatura
              buildSubscribeButton(),
              
              const SizedBox(height: 20),
              
              // Termos e condições
              buildTermsAndConditions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      children: [
        // Ícone premium
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFC7A87B),
                Color(0xFF8B5E3C),
              ],
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.workspace_premium,
            color: Colors.white,
            size: 48,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Título
        const Text(
          'Desbloqueie Todo\no Conteúdo Premium',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Subtítulo
        Text(
          'Tenha acesso ilimitado às melhores notícias de Moçambique e do mundo',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF333333).withOpacity(0.7),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildPlansSection() {
    return Column(
      children: [
        // Título da seção
        const Text(
          'Escolha seu plano',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Cards dos planos em lista vertical
        ...plans.asMap().entries.map((entry) {
          int index = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: buildPlanCard(index),
          );
        }).toList(),
      ],
    );
  }

  Widget buildPaymentMethodsSection() {
    return Column(
      children: [
        // Título da seção
        const Text(
          'Método de pagamento',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Cards dos métodos de pagamento
        ...paymentMethods.asMap().entries.map((entry) {
          int index = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: buildPaymentMethodCard(index),
          );
        }).toList(),
      ],
    );
  }

  Widget buildPaymentMethodCard(int index) {
    final method = paymentMethods[index];
    final isSelected = selectedPaymentMethod == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? method['color'].withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? method['color'] 
                : const Color(0xFFC7A87B).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? method['color'].withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Círculo de seleção
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? method['color'] : Colors.transparent,
                border: Border.all(
                  color: isSelected ? method['color'] : const Color(0xFFC7A87B),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            
            const SizedBox(width: 16),
            
            // Ícone do método
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: method['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                method['icon'],
                color: method['color'],
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Informações do método
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? method['color'] : const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF333333).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlanCard(int index) {
    final plan = plans[index];
    final isSelected = selectedPlan == index;
    final isPopular = plan['popular'] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC7A87B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFC7A87B) 
                : const Color(0xFFC7A87B).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? const Color(0xFFC7A87B).withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Círculo de seleção
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.transparent : const Color(0xFFC7A87B),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Color(0xFFC7A87B),
                    )
                  : null,
            ),
            
            const SizedBox(width: 16),
            
            // Informações do plano
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge popular + título
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          plan['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : const Color(0xFF333333),
                          ),
                        ),
                      ),
                      if (isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color(0xFFC7A87B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'POPULAR',
                            style: TextStyle(
                              color: isSelected ? const Color(0xFFC7A87B) : Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Duração
                  Text(
                    plan['duration'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected 
                          ? Colors.white.withOpacity(0.8)
                          : const Color(0xFF333333).withOpacity(0.7),
                    ),
                  ),
                  
                  // Economia (se houver)
                  if (plan['savings'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      plan['savings'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected 
                            ? Colors.white 
                            : const Color(0xFF8B5E3C),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Preço
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan['price'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF333333),
                  ),
                ),
                Text(
                  plan['period'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected 
                        ? Colors.white.withOpacity(0.8)
                        : const Color(0xFF333333).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'O que você ganha com o Premium:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Lista de benefícios
        ...benefits.map((benefit) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC7A87B),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  benefit,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget buildSubscribeButton() {
    final selectedPlanData = plans[selectedPlan];
    
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFC7A87B),
            Color(0xFF8B5E3C),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC7A87B).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          _processPurchase();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Assinar ${selectedPlanData['title']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTermsAndConditions() {
    return Column(
      children: [
        // Informações de pagamento
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.security,
                color: Color(0xFFC7A87B),
                size: 24,
              ),
              const SizedBox(height: 8),
              const Text(
                'Pagamentos Seguros',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Aceitamos M-Pesa e cartões Visa/Mastercard com segurança SSL',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF333333).withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Termos
        Text(
          'Ao assinar, você concorda com nossos Termos de Uso e Política de Privacidade. Pagamentos processados de forma segura. Você pode cancelar sua assinatura a qualquer momento através do seu perfil.',
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF333333).withOpacity(0.6),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Links
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Abrir termos de uso
              },
              child: const Text(
                'Termos de Uso',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFC7A87B),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                // Abrir política de privacidade
              },
              child: const Text(
                'Política de Privacidade',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFC7A87B),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _processPurchase() {
    final selectedPlanData = plans[selectedPlan];
    final selectedPaymentData = paymentMethods[selectedPaymentMethod];
    
    if (selectedPaymentMethod == 0) {
      // M-Pesa
      _processMpesaPayment(selectedPlanData);
    } else {
      // Cartão
      _processCardPayment(selectedPlanData);
    }
  }

  void _processMpesaPayment(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.phone_android,
                color: const Color(0xFF00A651),
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                'Pagamento M-Pesa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plano: ${plan['title']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Valor: ${plan['price']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E88E5),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Instruções:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('1. Abra o aplicativo M-Pesa'),
              const Text('2. Selecione "Pagar Serviços"'),
              const Text('3. Código do comerciante: 171717'),
              const Text('4. Confirme o pagamento'),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Aguardando confirmação do pagamento...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1E88E5),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF333333)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessDialog(plan);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simular Pagamento'),
            ),
          ],
        );
      },
    );
  }

  void _processCardPayment(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.credit_card,
                color: const Color(0xFF1976D2),
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                'Pagamento por Cartão',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plano: ${plan['title']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Valor: ${plan['price']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 16),
              
              // Simulação de formulário de cartão
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Número do cartão',
                        hintText: '**** **** **** 1234',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Validade',
                              hintText: 'MM/AA',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              hintText: '123',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF333333)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showProcessingDialog(plan);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
              ),
              child: const Text('Pagar Agora'),
            ),
          ],
        );
      },
    );
  }

  void _showProcessingDialog(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
          ),
        );
      },
    );
    
    // Simular processamento
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Fechar loading
      _showSuccessDialog(plan);
    });
  }

  void _showSuccessDialog(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'Pagamento Aprovado!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sua assinatura ${plan['title']} foi ativada com sucesso!',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Plano: ${plan['title']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Valor pago: ${plan['price']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Método: ${paymentMethods[selectedPaymentMethod]['name']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar dialog
                Navigator.of(context).pop(); // Voltar para a tela anterior
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC7A87B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
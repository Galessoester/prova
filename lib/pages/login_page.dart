//import 3
import 'package:expense_tracker/repository/auth_repository.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final senhaController = TextEditingController();
  final emailController = TextEditingController();
  bool obscureText = true;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.3),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBemVindo(),
                    const SizedBox(height: 20),
                    _buildEmail(),
                    const SizedBox(height: 20),
                    _buildSenha(),
                    const SizedBox(height: 10),
                    _buildButton(),
                    const SizedBox(height: 10),
                    _buildRegistrar(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Text _buildBemVindo() {
    return const Text(
      "Bem Vindo!",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Digite seu e-mail",
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'O e-mail é obrigatório';
        }
        if (!validarEmail(value)){
          return 'Deve ser um e-mail valido';
        }
        return null;
      },
    );
  }

  TextFormField _buildSenha() {
    return TextFormField(
      controller: senhaController,
      obscureText: obscureText, 
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Digite sua senha",
        prefixIcon: Icon(Icons.lock_outline_rounded),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText; 
            });
          },
          child: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'A senha é obrigatória';
        }
        if(value.length < 5 || value.length > 12) {
          return 'A senha deve conter entre 5 e 12 caracteres';
        }
        return null;
      },
    );
    // Icone para ocultar a senha visibility_off_outlined
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          onTapBtnSignUp();
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final repositorio = AuthRepository();
            final login = await repositorio.login(emailController.text, senhaController.text);
            if (login){
              Navigator.pushNamed(context, '/home');
            } else {
              _exibirMensagem('Login inválido');
            }
          }
        },
        child: const Text('Login'),
      ),
    );
  }

  Widget _buildRegistrar() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/registrar');
      },
      child: RichText(
          text: TextSpan(children: <InlineSpan>[
            TextSpan(
              text: "Não tem uma conta?",
              style: TextStyle(
                  color: Colors.blueGrey.shade300,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
            TextSpan(
              text: ' ',
              style: TextStyle(
                  color: Colors.indigo.shade300,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: "Registrar-se",
              style: TextStyle(
                  color: Colors.lightBlue.shade300,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            )
          ]),
          textAlign: TextAlign.center),
    );
  }

  bool validarEmail(String email) {
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  void _exibirMensagem(String mensagem) {
    final snackbar = SnackBar(content: Text(mensagem));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void onTapBtnSignUp() {}
}

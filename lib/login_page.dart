import 'package:flutter/material.dart';
import 'package:login_register/controllers/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;
  bool _hasError = false; // Track error state

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _hasError = false; // Reset error state
      });

      try {
        final user = await AuthService().login(
          _usernameController.text,
          _passwordController.text,
        );

        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            _errorMessage = 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง';
            _hasError = true; // Set error state
            _passwordController.clear();
          });
        }
      } catch (error) {
        setState(() {
          _hasError = true; // Set error state on failure
          _passwordController.clear();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  Future<void> _onRefresh() async {
    setState(() {
      _usernameController.clear();
      _passwordController.clear();
      _errorMessage = null; // Reset error message
      _hasError = false; // Reset error state
    });

    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping outside input
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1),
                    Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        fontSize: 39,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'เรายินดีที่ได้พบคุณอีกครั้ง กรุณาเข้าสู่ระบบเพื่อ    ดำเนินการต่อ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'ชื่อผู้ใช้',
                                  suffixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorText: _hasError
                                      ? 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'
                                      : null,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกชื่อผู้ใช้';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 24),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'รหัสผ่าน',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorText: _hasError
                                      ? 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'
                                      : null,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกรหัสผ่าน';
                                  }
                                  return null;
                                },
                              ),
                              if (_errorMessage != null) ...[
                                SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                              SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text('เข้าสู่ระบบ'),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: _navigateToRegister,
                        child: Text(
                          'ยังไม่มีบัญชี? สมัครสมาชิก',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

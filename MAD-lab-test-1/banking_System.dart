// Main Dart file

void main() {
  // Create a regular bank account
  BankAccount acc1 = BankAccount('1001', 'Alice');
  acc1.deposit(500);
  acc1.withdraw(100);
  print(acc1);

  // Create a savings account
  BankAccount acc2 = SavingsAccount('2002', 'Bob', 0.05);
  acc2.deposit(1000);
  acc2.withdraw(200);
  // Apply interest
  (acc2 as SavingsAccount).applyInterest();
  print(acc2);

  // Polymorphism demonstration
  List<BankAccount> accounts = [acc1, acc2];
  for (var account in accounts) {
    print('Polymorphic Account Info:\n$account\n');
  }
}

/// Base class: BankAccount
class BankAccount {
  // Encapsulated private fields
  String _accountNumber;
  String _accountHolderName;
  double _balance = 0.0;

  // Constructor
  BankAccount(this._accountNumber, this._accountHolderName);

  // Getter methods
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;

  // Deposit method with validation
  void deposit(double amount) {
    if (amount <= 0) {
      print('Error: Deposit amount must be positive.');
      return;
    }
    _balance += amount;
    print(
      'Deposited \$${amount.toStringAsFixed(2)} to $_accountHolderName\'s account.',
    );
  }

  // Withdraw method with balance check
  void withdraw(double amount) {
    if (amount <= 0) {
      print('Error: Withdrawal amount must be positive.');
      return;
    }
    if (amount > _balance) {
      print('Error: Insufficient balance.');
      return;
    }
    _balance -= amount;
    print(
      'Withdrew \$${amount.toStringAsFixed(2)} from $_accountHolderName\'s account.',
    );
  }

  // Override toString to display account info
  @override
  String toString() {
    return 'Account Number: $_accountNumber\n'
        'Holder Name: $_accountHolderName\n'
        'Balance: \$${_balance.toStringAsFixed(2)}';
  }
}

/// Subclass: SavingsAccount
class SavingsAccount extends BankAccount {
  double _interestRate;

  // Constructor
  SavingsAccount(
    String accountNumber,
    String accountHolderName,
    this._interestRate,
  ) : super(accountNumber, accountHolderName);

  // Method to apply interest
  void applyInterest() {
    double interest = balance * _interestRate;
    deposit(interest); // Reuse deposit method
    print(
      'Interest of \$${interest.toStringAsFixed(2)} applied to ${accountHolderName}\'s account.',
    );
  }

  // Override toString to include interest rate
  @override
  String toString() {
    return super.toString() +
        '\nAccount Type: Savings\nInterest Rate: ${(_interestRate * 100).toStringAsFixed(2)}%';
  }
}

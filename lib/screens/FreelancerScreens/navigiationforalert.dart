class NavigationState {
  static final NavigationState _instance = NavigationState._internal();

  bool fromLogin = false;

  factory NavigationState() {
    return _instance;
  }

  NavigationState._internal();
}
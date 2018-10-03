import Prelude
import ReactiveSwift
import Result
import KsApi

public protocol SettingsAccountViewModelInputs {
  func currencyPickerShown()
  func didSelectRow(cellType: SettingsAccountCellType)
  func dismissedCurrencyPicker()
  func settingsCellTapped(cellType: SettingsAccountCellType)
  func tapped()
  func viewDidLoad()
}

public protocol SettingsAccountViewModelOutputs {
  var dismissPicker: Signal<Void, NoError> { get }
  var reloadData: Signal<Void, NoError> { get }
  var showCurrencyPicker: Signal<Bool, NoError> { get }
  var transitionToViewController: Signal<UIViewController, NoError> { get }
}

public protocol SettingsAccountViewModelType {
  var inputs: SettingsAccountViewModelInputs { get }
  var outputs: SettingsAccountViewModelOutputs { get }
}

public final class SettingsAccountViewModel: SettingsAccountViewModelInputs,
SettingsAccountViewModelOutputs, SettingsAccountViewModelType {

  public init() {
    self.reloadData = self.viewDidLoadProperty.signal

    let currencyCellSelected = self.selectedCellType.signal.skipNil()
      .filter { $0 == .currency }

    self.showCurrencyPicker = Signal.merge(
      currencyCellSelected.signal.mapConst(true),
      currencyPickerShownProperty.signal.mapConst(false),
      dismissedCurrencyPickerProperty.signal.mapConst(false)
      ).skipRepeats()

    self.dismissPicker = self.tappedProperty.signal

    self.transitionToViewController = self.selectedCellTypeProperty.signal.skipNil()
      .map { SettingsAccountViewModel.viewController(for: $0) }
      .skipNil()
  }

  fileprivate let currencyPickerShownProperty = MutableProperty(())
  public func currencyPickerShown() {
    self.currencyPickerShownProperty.value = ()
  }

  fileprivate let dismissedCurrencyPickerProperty = MutableProperty(())
  public func dismissedCurrencyPicker() {
    self.dismissedCurrencyPickerProperty.value = ()
  }

  private let selectedCellTypeProperty = MutableProperty<SettingsAccountCellType?>(nil)
  public func settingsCellTapped(cellType: SettingsAccountCellType) {
    self.selectedCellTypeProperty.value = cellType
  }

  fileprivate let selectedCellType = MutableProperty<SettingsAccountCellType?>(nil)
  public func didSelectRow(cellType: SettingsAccountCellType) {
    self.selectedCellType.value = cellType
  }

  fileprivate let tappedProperty = MutableProperty(())
  public func tapped() {
    self.tappedProperty.value = ()
  }

  private let viewDidLoadProperty = MutableProperty(())
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  public let dismissPicker: Signal<Void, NoError>
  public let reloadData: Signal<Void, NoError>
  public let showCurrencyPicker: Signal<Bool, NoError>
  public let transitionToViewController: Signal<UIViewController, NoError>

  public var inputs: SettingsAccountViewModelInputs { return self }
  public var outputs: SettingsAccountViewModelOutputs { return self }
}

// MARK: Helpers
extension SettingsAccountViewModel {
  static func viewController(for cellType: SettingsAccountCellType) -> UIViewController? {
    return nil
  }
}

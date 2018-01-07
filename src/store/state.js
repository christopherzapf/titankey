export default {
  currentRoute: null,
  web3: {
    address: null,
    coinbase: null,
    error: null,
    instance: null,
    isInjected: false,
    networkId: null
  },
  user: {
    coinbase: '',
    email: '',
    firstName: '',
    lastName: '',
    titanName: '',
    nameIsEmail: true,
    hasKeys: false,
    hasCoinbase: false,
    hasWeb3InjectedBrowser: false,
    isConnectedToApprovedNetwork: false,
    isLoggedIn: false
  },
  publicKey: {
    currency: [{
      cur: '',
      key: [],
      name: [],
      isDefault: [],
      lastChange: []
    }]
  }
}

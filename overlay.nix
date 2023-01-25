self: super:

{
    alephium = self.callPackage ./alephium { };
    ralphc = self.callPackage ./ralphc { };
}

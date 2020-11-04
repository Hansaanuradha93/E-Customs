import Firebase

extension Timestamp {
    func toString() -> String {
        let date = self.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}

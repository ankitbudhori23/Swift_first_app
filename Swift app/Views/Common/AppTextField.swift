import SwiftUI

struct AppTextField: View {
    let title: String
    @Binding var text: String

    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.body)
                .foregroundColor(.gray)

            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .padding(12)
            .background(Color(.systemGray5))
            .cornerRadius(10)
        }
    }
}

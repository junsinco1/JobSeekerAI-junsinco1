import SwiftUI
import UIKit

struct ResumeListView: View {
    @StateObject var viewModel: ResumeViewModel
    @State private var isShowingUpload = false
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: ResumeViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Quick Actions
                HStack(spacing: 15) {
                    NavigationLink(destination: JobSuggestionsView(viewModel: viewModel, resumeContent: viewModel.selectedResume?.content ?? "")) {
                        VStack {
                            Image(systemName: "sparkles")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity, height: 100)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: ResumeUploadView(viewModel: viewModel)) {
                        VStack {
                            Image(systemName: "doc.badge.plus")
                                .font(.headline)
                            Text("Upload Resume")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, height: 100)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding()
                
                // Resume List
                if viewModel.resumes.isEmpty {
                    ContentUnavailableView("No Resumes", systemImage: "doc.text", description: Text("Create your first resume to get AI-powered job suggestions."))
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(10)
                } else {
                    List(viewModel.resumes) { resume in
                        NavigationLink(destination: ResumeEditorView(resume: resume)) {
                            VStack(alignment: .leading) {
                                Text(resume.name).font(.headline)
                                if let tailored = resume.tailoredContent {
                                    Text("Tailored content available").font(.caption2).foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Resumes")
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { _ in
                viewModel.applyFilters()
            }
            .onAppear {
                viewModel.fetchResumes()
            }
        }
    }
}

struct ResumeUploadView: View {
    @ObservedObject var viewModel: ResumeViewModel
    @State private var importMethod: ImportMethod = .text
    @State private var name: String = ""
    @State private var content: String = ""
    @State private var showPicker: Bool = false
    @State private var isPicking: Bool = false
    
    enum ImportMethod { case text, file }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if importMethod == .text {
                    Form {
                        Section(header: Text("Import Method")) {
                            Picker("Choose", selection: $importMethod) {
                                Text("Paste Content").tag(.text)
                                Text("Upload File").tag(.file)
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        if importMethod == .text {
                            Section(header: Text("Resume Details")) {
                                TextField("Resume Name", text: $name)
                                    .textWrapperStyle(.plain)
                                TextEditor(text: $content)
                                    .frame(height: 250)
                                    .padding(10)
                            }
                        } else {
                            Section {
                                VStack(spacing: 30) {
                                    Image(systemName: "doc.badge.plus")
                                        .font(.system(size: 80))
                                        .foregroundColor(.gray)
                                    
                                    VStack(spacing: 10) {
                                        Text("Select a PDF or Docx file")
                                            .font(.headline)
                                        Text("to import your resume.")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .multilineTextAlignment(.center)
                                    
                                    Button(action: { showPicker = true }) {
                                        Text("Select File")
                                            .fontWeight(.bold)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .disabled(isPicking)
                                    
                                    if isPicking {
                                        ProgressView("Parsing File...")
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Form {
                        Section {
                            Button(action: { importMethod = .text }) {
                                Text("Back to Text Input")
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Import Resume")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        name = ""
                        content = ""
                    }
                }
            }
            .sheet(isPresented: $showPicker) {
                DocumentPicker(isPresented: $showPicker) { url in
                    isPicking = true
                    viewModel.parseAndSaveResume(url: url)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isPicking = false
                        showPicker = false
                    }
                }
            }
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onPick: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .data])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick, isPresented: $isPresented)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL) -> Void
        @Binding var isPresented: Bool
        
        init(onPick: @escaping (URL) -> Void, isPresented: Binding<Bool>) {
            self.onPick = onPick
            self.isPresented = isPresented
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onPick(url)
            isPresented = false
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didCancelURLHandling completion: Bool) {
            isPresented = false
        }
    }
}

struct ResumeEditorView: View {
    @ObservedObject var viewModel: ResumeViewModel
    var resume: Resume
    
    @State private var content: String = ""
    @State private var jobDescription: String = ""
    @State private var isTailoring: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(height: 300)
                }
                
                Section(header: Text("Tailor for Job")) {
                    TextEditor(text: $jobDescription)
                        .frame(height: 100)
                    
                    Button(action: {
                        isTailoring = true
                        viewModel.tailorResume(jobDescription: jobDescription)
                    }) {
                        if isTailoring {
                            ProgressView()
                        } else {
                            Text("Tailor Resume")
                                .fontWeight(.bold)
                        }
                    }
                    .disabled(jobDescription.isEmpty)
                }
            }
            .navigationTitle("Edit Resume")
            .onAppear {
                content = resume.content
            }
        }
    }
}

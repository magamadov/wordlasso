//
//  main.swift
//  wordlasso
//
//  Created by ZELIMKHAN MAGAMADOV on 01.02.2021.
//

import Foundation
import ArgumentParser

struct Wordlasso: ParsableCommand {
  @Argument(help: """
		The word template to match, with \(WordFinder.wildcard) as \
		placeholders. Leaving this blank will enter interactive mode.
		""")
  var template: String?
	
	@Flag(inversion: .prefixedNo, help: "Perform case-insensitive matches.")
	var ignoreCase: Bool = true
	
	@Option(name: .customLong("wordfile"), help: "Path to a newline-delimited word list.")
	var wordListPath = "/usr/share/dict/words"
	
	@Option(name: .short, help: "Maximum nubers of result")
	var numOfResult = 0
  
  func run() throws {
    let wordFinder = try WordFinder(wordListPath: wordListPath, ignoreCase: ignoreCase)
    
		if let template = template {
      findAndPrintMatches(for: template, using: wordFinder)
    } else {
      while true {
        print("Enter word template: ", terminator: "")
        let template = readLine() ?? ""
        if template.isEmpty { return }
        findAndPrintMatches(for: template, using: wordFinder)
      }
    }
  }
  
  private func findAndPrintMatches(for template: String, using wordFinder: WordFinder) {
    let matches = wordFinder.findMatches(for: template)
		print("Found \(numOfResult == 0 ? "\(matches.count)" : "\(numOfResult)") \(matches.count == 1 ? "match" : "matches")")
		
		if numOfResult != 0 {
			for index in 0..<numOfResult {
				print(matches[index])
			}
		} else {
			for match in matches {
				print(match)
			}
		}
  }
}

Wordlasso.main()

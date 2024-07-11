// Copyright 2024 Google LLC All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package apis

const (
	// Foo1 enum value for testing CRD defaulting
	Foo1 Foos = "foo1"
	// Foo2 enum value for testing CRD defaulting
	Foo2 Foos = "foo2"
	// Foo3 enum value for testing CRD defaulting
	Foo3 Foos = "foo3"
)

// Foos enum values for testing CRD defaulting
type Foos string

// Bars tracks the initial player capacity
type Bars struct {
	BarCapacity int64 `json:"barCapacity,omitempty"`
}

// Bazes tracks the initial player capacity
type Bazes struct {
	BazCapacity int64 `json:"bazCapacity,omitempty"`
}

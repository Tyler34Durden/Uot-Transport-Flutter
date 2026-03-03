import 'package:uot_transport/core/utilities.dart';

import '../entities/ticket_request.dart';
import '../repositories/trips_repository.dart';

class CreateTicketUseCase {
  const CreateTicketUseCase(this.repository);

  final TripsRepository repository;

  ResultFuture<void> call({
    required TicketRequest request,
    required String token,
  }) {
    return repository.createTicket(request: request, token: token);
  }
}


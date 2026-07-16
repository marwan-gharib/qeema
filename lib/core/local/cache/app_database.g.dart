// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedAssetsTableTable extends CachedAssetsTable
    with TableInfo<$CachedAssetsTableTable, CachedAssetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAssetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetTypeCodeMeta = const VerificationMeta(
    'assetTypeCode',
  );
  @override
  late final GeneratedColumn<String> assetTypeCode = GeneratedColumn<String>(
    'asset_type_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetTypeIdMeta = const VerificationMeta(
    'assetTypeId',
  );
  @override
  late final GeneratedColumn<String> assetTypeId = GeneratedColumn<String>(
    'asset_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceAtEntryMeta = const VerificationMeta(
    'priceAtEntry',
  );
  @override
  late final GeneratedColumn<String> priceAtEntry = GeneratedColumn<String>(
    'price_at_entry',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentUnitPriceMeta = const VerificationMeta(
    'currentUnitPrice',
  );
  @override
  late final GeneratedColumn<String> currentUnitPrice = GeneratedColumn<String>(
    'current_unit_price',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryDateMeta = const VerificationMeta(
    'entryDate',
  );
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
    'entry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pendingSyncMeta = const VerificationMeta(
    'pendingSync',
  );
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
    'pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    assetTypeCode,
    assetTypeId,
    amount,
    priceAtEntry,
    currentUnitPrice,
    entryDate,
    note,
    pendingSync,
    lastSyncedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_assets_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedAssetsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('asset_type_code')) {
      context.handle(
        _assetTypeCodeMeta,
        assetTypeCode.isAcceptableOrUnknown(
          data['asset_type_code']!,
          _assetTypeCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetTypeCodeMeta);
    }
    if (data.containsKey('asset_type_id')) {
      context.handle(
        _assetTypeIdMeta,
        assetTypeId.isAcceptableOrUnknown(
          data['asset_type_id']!,
          _assetTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetTypeIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('price_at_entry')) {
      context.handle(
        _priceAtEntryMeta,
        priceAtEntry.isAcceptableOrUnknown(
          data['price_at_entry']!,
          _priceAtEntryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_priceAtEntryMeta);
    }
    if (data.containsKey('current_unit_price')) {
      context.handle(
        _currentUnitPriceMeta,
        currentUnitPrice.isAcceptableOrUnknown(
          data['current_unit_price']!,
          _currentUnitPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentUnitPriceMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(
        _entryDateMeta,
        entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
        _pendingSyncMeta,
        pendingSync.isAcceptableOrUnknown(
          data['pending_sync']!,
          _pendingSyncMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedAssetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAssetsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      assetTypeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_type_code'],
      )!,
      assetTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_type_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount'],
      )!,
      priceAtEntry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_at_entry'],
      )!,
      currentUnitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_unit_price'],
      )!,
      entryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      pendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_sync'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedAssetsTableTable createAlias(String alias) {
    return $CachedAssetsTableTable(attachedDatabase, alias);
  }
}

class CachedAssetsTableData extends DataClass
    implements Insertable<CachedAssetsTableData> {
  final String id;
  final String userId;
  final String assetTypeCode;
  final String assetTypeId;
  final String amount;
  final String priceAtEntry;
  final String currentUnitPrice;
  final DateTime entryDate;
  final String? note;
  final bool pendingSync;
  final DateTime? lastSyncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CachedAssetsTableData({
    required this.id,
    required this.userId,
    required this.assetTypeCode,
    required this.assetTypeId,
    required this.amount,
    required this.priceAtEntry,
    required this.currentUnitPrice,
    required this.entryDate,
    this.note,
    required this.pendingSync,
    this.lastSyncedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['asset_type_code'] = Variable<String>(assetTypeCode);
    map['asset_type_id'] = Variable<String>(assetTypeId);
    map['amount'] = Variable<String>(amount);
    map['price_at_entry'] = Variable<String>(priceAtEntry);
    map['current_unit_price'] = Variable<String>(currentUnitPrice);
    map['entry_date'] = Variable<DateTime>(entryDate);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['pending_sync'] = Variable<bool>(pendingSync);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedAssetsTableCompanion toCompanion(bool nullToAbsent) {
    return CachedAssetsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      assetTypeCode: Value(assetTypeCode),
      assetTypeId: Value(assetTypeId),
      amount: Value(amount),
      priceAtEntry: Value(priceAtEntry),
      currentUnitPrice: Value(currentUnitPrice),
      entryDate: Value(entryDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      pendingSync: Value(pendingSync),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedAssetsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAssetsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      assetTypeCode: serializer.fromJson<String>(json['assetTypeCode']),
      assetTypeId: serializer.fromJson<String>(json['assetTypeId']),
      amount: serializer.fromJson<String>(json['amount']),
      priceAtEntry: serializer.fromJson<String>(json['priceAtEntry']),
      currentUnitPrice: serializer.fromJson<String>(json['currentUnitPrice']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      note: serializer.fromJson<String?>(json['note']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'assetTypeCode': serializer.toJson<String>(assetTypeCode),
      'assetTypeId': serializer.toJson<String>(assetTypeId),
      'amount': serializer.toJson<String>(amount),
      'priceAtEntry': serializer.toJson<String>(priceAtEntry),
      'currentUnitPrice': serializer.toJson<String>(currentUnitPrice),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'note': serializer.toJson<String?>(note),
      'pendingSync': serializer.toJson<bool>(pendingSync),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedAssetsTableData copyWith({
    String? id,
    String? userId,
    String? assetTypeCode,
    String? assetTypeId,
    String? amount,
    String? priceAtEntry,
    String? currentUnitPrice,
    DateTime? entryDate,
    Value<String?> note = const Value.absent(),
    bool? pendingSync,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CachedAssetsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    assetTypeCode: assetTypeCode ?? this.assetTypeCode,
    assetTypeId: assetTypeId ?? this.assetTypeId,
    amount: amount ?? this.amount,
    priceAtEntry: priceAtEntry ?? this.priceAtEntry,
    currentUnitPrice: currentUnitPrice ?? this.currentUnitPrice,
    entryDate: entryDate ?? this.entryDate,
    note: note.present ? note.value : this.note,
    pendingSync: pendingSync ?? this.pendingSync,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedAssetsTableData copyWithCompanion(CachedAssetsTableCompanion data) {
    return CachedAssetsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      assetTypeCode: data.assetTypeCode.present
          ? data.assetTypeCode.value
          : this.assetTypeCode,
      assetTypeId: data.assetTypeId.present
          ? data.assetTypeId.value
          : this.assetTypeId,
      amount: data.amount.present ? data.amount.value : this.amount,
      priceAtEntry: data.priceAtEntry.present
          ? data.priceAtEntry.value
          : this.priceAtEntry,
      currentUnitPrice: data.currentUnitPrice.present
          ? data.currentUnitPrice.value
          : this.currentUnitPrice,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      note: data.note.present ? data.note.value : this.note,
      pendingSync: data.pendingSync.present
          ? data.pendingSync.value
          : this.pendingSync,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAssetsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('assetTypeCode: $assetTypeCode, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('amount: $amount, ')
          ..write('priceAtEntry: $priceAtEntry, ')
          ..write('currentUnitPrice: $currentUnitPrice, ')
          ..write('entryDate: $entryDate, ')
          ..write('note: $note, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    assetTypeCode,
    assetTypeId,
    amount,
    priceAtEntry,
    currentUnitPrice,
    entryDate,
    note,
    pendingSync,
    lastSyncedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAssetsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.assetTypeCode == this.assetTypeCode &&
          other.assetTypeId == this.assetTypeId &&
          other.amount == this.amount &&
          other.priceAtEntry == this.priceAtEntry &&
          other.currentUnitPrice == this.currentUnitPrice &&
          other.entryDate == this.entryDate &&
          other.note == this.note &&
          other.pendingSync == this.pendingSync &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CachedAssetsTableCompanion
    extends UpdateCompanion<CachedAssetsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> assetTypeCode;
  final Value<String> assetTypeId;
  final Value<String> amount;
  final Value<String> priceAtEntry;
  final Value<String> currentUnitPrice;
  final Value<DateTime> entryDate;
  final Value<String?> note;
  final Value<bool> pendingSync;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedAssetsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.assetTypeCode = const Value.absent(),
    this.assetTypeId = const Value.absent(),
    this.amount = const Value.absent(),
    this.priceAtEntry = const Value.absent(),
    this.currentUnitPrice = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.note = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAssetsTableCompanion.insert({
    required String id,
    required String userId,
    required String assetTypeCode,
    required String assetTypeId,
    required String amount,
    required String priceAtEntry,
    required String currentUnitPrice,
    required DateTime entryDate,
    this.note = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       assetTypeCode = Value(assetTypeCode),
       assetTypeId = Value(assetTypeId),
       amount = Value(amount),
       priceAtEntry = Value(priceAtEntry),
       currentUnitPrice = Value(currentUnitPrice),
       entryDate = Value(entryDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedAssetsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? assetTypeCode,
    Expression<String>? assetTypeId,
    Expression<String>? amount,
    Expression<String>? priceAtEntry,
    Expression<String>? currentUnitPrice,
    Expression<DateTime>? entryDate,
    Expression<String>? note,
    Expression<bool>? pendingSync,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (assetTypeCode != null) 'asset_type_code': assetTypeCode,
      if (assetTypeId != null) 'asset_type_id': assetTypeId,
      if (amount != null) 'amount': amount,
      if (priceAtEntry != null) 'price_at_entry': priceAtEntry,
      if (currentUnitPrice != null) 'current_unit_price': currentUnitPrice,
      if (entryDate != null) 'entry_date': entryDate,
      if (note != null) 'note': note,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAssetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? assetTypeCode,
    Value<String>? assetTypeId,
    Value<String>? amount,
    Value<String>? priceAtEntry,
    Value<String>? currentUnitPrice,
    Value<DateTime>? entryDate,
    Value<String?>? note,
    Value<bool>? pendingSync,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedAssetsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      assetTypeCode: assetTypeCode ?? this.assetTypeCode,
      assetTypeId: assetTypeId ?? this.assetTypeId,
      amount: amount ?? this.amount,
      priceAtEntry: priceAtEntry ?? this.priceAtEntry,
      currentUnitPrice: currentUnitPrice ?? this.currentUnitPrice,
      entryDate: entryDate ?? this.entryDate,
      note: note ?? this.note,
      pendingSync: pendingSync ?? this.pendingSync,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (assetTypeCode.present) {
      map['asset_type_code'] = Variable<String>(assetTypeCode.value);
    }
    if (assetTypeId.present) {
      map['asset_type_id'] = Variable<String>(assetTypeId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (priceAtEntry.present) {
      map['price_at_entry'] = Variable<String>(priceAtEntry.value);
    }
    if (currentUnitPrice.present) {
      map['current_unit_price'] = Variable<String>(currentUnitPrice.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedAssetsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('assetTypeCode: $assetTypeCode, ')
          ..write('assetTypeId: $assetTypeId, ')
          ..write('amount: $amount, ')
          ..write('priceAtEntry: $priceAtEntry, ')
          ..write('currentUnitPrice: $currentUnitPrice, ')
          ..write('entryDate: $entryDate, ')
          ..write('note: $note, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedAssetHistoryTableTable extends CachedAssetHistoryTable
    with TableInfo<$CachedAssetHistoryTableTable, CachedAssetHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAssetHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetIdMeta = const VerificationMeta(
    'assetId',
  );
  @override
  late final GeneratedColumn<String> assetId = GeneratedColumn<String>(
    'asset_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldNameMeta = const VerificationMeta(
    'fieldName',
  );
  @override
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
    'field_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oldValueMeta = const VerificationMeta(
    'oldValue',
  );
  @override
  late final GeneratedColumn<String> oldValue = GeneratedColumn<String>(
    'old_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newValueMeta = const VerificationMeta(
    'newValue',
  );
  @override
  late final GeneratedColumn<String> newValue = GeneratedColumn<String>(
    'new_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assetId,
    fieldName,
    oldValue,
    newValue,
    changedAt,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_asset_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedAssetHistoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_id')) {
      context.handle(
        _assetIdMeta,
        assetId.isAcceptableOrUnknown(data['asset_id']!, _assetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_assetIdMeta);
    }
    if (data.containsKey('field_name')) {
      context.handle(
        _fieldNameMeta,
        fieldName.isAcceptableOrUnknown(data['field_name']!, _fieldNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldNameMeta);
    }
    if (data.containsKey('old_value')) {
      context.handle(
        _oldValueMeta,
        oldValue.isAcceptableOrUnknown(data['old_value']!, _oldValueMeta),
      );
    }
    if (data.containsKey('new_value')) {
      context.handle(
        _newValueMeta,
        newValue.isAcceptableOrUnknown(data['new_value']!, _newValueMeta),
      );
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedAssetHistoryTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAssetHistoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      assetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_id'],
      )!,
      fieldName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_name'],
      )!,
      oldValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}old_value'],
      ),
      newValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_value'],
      ),
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $CachedAssetHistoryTableTable createAlias(String alias) {
    return $CachedAssetHistoryTableTable(attachedDatabase, alias);
  }
}

class CachedAssetHistoryTableData extends DataClass
    implements Insertable<CachedAssetHistoryTableData> {
  final String id;
  final String assetId;
  final String fieldName;
  final String? oldValue;
  final String? newValue;
  final DateTime changedAt;
  final DateTime? lastSyncedAt;
  const CachedAssetHistoryTableData({
    required this.id,
    required this.assetId,
    required this.fieldName,
    this.oldValue,
    this.newValue,
    required this.changedAt,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_id'] = Variable<String>(assetId);
    map['field_name'] = Variable<String>(fieldName);
    if (!nullToAbsent || oldValue != null) {
      map['old_value'] = Variable<String>(oldValue);
    }
    if (!nullToAbsent || newValue != null) {
      map['new_value'] = Variable<String>(newValue);
    }
    map['changed_at'] = Variable<DateTime>(changedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  CachedAssetHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return CachedAssetHistoryTableCompanion(
      id: Value(id),
      assetId: Value(assetId),
      fieldName: Value(fieldName),
      oldValue: oldValue == null && nullToAbsent
          ? const Value.absent()
          : Value(oldValue),
      newValue: newValue == null && nullToAbsent
          ? const Value.absent()
          : Value(newValue),
      changedAt: Value(changedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory CachedAssetHistoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAssetHistoryTableData(
      id: serializer.fromJson<String>(json['id']),
      assetId: serializer.fromJson<String>(json['assetId']),
      fieldName: serializer.fromJson<String>(json['fieldName']),
      oldValue: serializer.fromJson<String?>(json['oldValue']),
      newValue: serializer.fromJson<String?>(json['newValue']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetId': serializer.toJson<String>(assetId),
      'fieldName': serializer.toJson<String>(fieldName),
      'oldValue': serializer.toJson<String?>(oldValue),
      'newValue': serializer.toJson<String?>(newValue),
      'changedAt': serializer.toJson<DateTime>(changedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  CachedAssetHistoryTableData copyWith({
    String? id,
    String? assetId,
    String? fieldName,
    Value<String?> oldValue = const Value.absent(),
    Value<String?> newValue = const Value.absent(),
    DateTime? changedAt,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => CachedAssetHistoryTableData(
    id: id ?? this.id,
    assetId: assetId ?? this.assetId,
    fieldName: fieldName ?? this.fieldName,
    oldValue: oldValue.present ? oldValue.value : this.oldValue,
    newValue: newValue.present ? newValue.value : this.newValue,
    changedAt: changedAt ?? this.changedAt,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  CachedAssetHistoryTableData copyWithCompanion(
    CachedAssetHistoryTableCompanion data,
  ) {
    return CachedAssetHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      assetId: data.assetId.present ? data.assetId.value : this.assetId,
      fieldName: data.fieldName.present ? data.fieldName.value : this.fieldName,
      oldValue: data.oldValue.present ? data.oldValue.value : this.oldValue,
      newValue: data.newValue.present ? data.newValue.value : this.newValue,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAssetHistoryTableData(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('fieldName: $fieldName, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('changedAt: $changedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    assetId,
    fieldName,
    oldValue,
    newValue,
    changedAt,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAssetHistoryTableData &&
          other.id == this.id &&
          other.assetId == this.assetId &&
          other.fieldName == this.fieldName &&
          other.oldValue == this.oldValue &&
          other.newValue == this.newValue &&
          other.changedAt == this.changedAt &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class CachedAssetHistoryTableCompanion
    extends UpdateCompanion<CachedAssetHistoryTableData> {
  final Value<String> id;
  final Value<String> assetId;
  final Value<String> fieldName;
  final Value<String?> oldValue;
  final Value<String?> newValue;
  final Value<DateTime> changedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const CachedAssetHistoryTableCompanion({
    this.id = const Value.absent(),
    this.assetId = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAssetHistoryTableCompanion.insert({
    required String id,
    required String assetId,
    required String fieldName,
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    required DateTime changedAt,
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetId = Value(assetId),
       fieldName = Value(fieldName),
       changedAt = Value(changedAt);
  static Insertable<CachedAssetHistoryTableData> custom({
    Expression<String>? id,
    Expression<String>? assetId,
    Expression<String>? fieldName,
    Expression<String>? oldValue,
    Expression<String>? newValue,
    Expression<DateTime>? changedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetId != null) 'asset_id': assetId,
      if (fieldName != null) 'field_name': fieldName,
      if (oldValue != null) 'old_value': oldValue,
      if (newValue != null) 'new_value': newValue,
      if (changedAt != null) 'changed_at': changedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAssetHistoryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? assetId,
    Value<String>? fieldName,
    Value<String?>? oldValue,
    Value<String?>? newValue,
    Value<DateTime>? changedAt,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return CachedAssetHistoryTableCompanion(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      fieldName: fieldName ?? this.fieldName,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
      changedAt: changedAt ?? this.changedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetId.present) {
      map['asset_id'] = Variable<String>(assetId.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (oldValue.present) {
      map['old_value'] = Variable<String>(oldValue.value);
    }
    if (newValue.present) {
      map['new_value'] = Variable<String>(newValue.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedAssetHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('assetId: $assetId, ')
          ..write('fieldName: $fieldName, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('changedAt: $changedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedMarketPricesTableTable extends CachedMarketPricesTable
    with TableInfo<$CachedMarketPricesTableTable, CachedMarketPricesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedMarketPricesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetTypeCodeMeta = const VerificationMeta(
    'assetTypeCode',
  );
  @override
  late final GeneratedColumn<String> assetTypeCode = GeneratedColumn<String>(
    'asset_type_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<String> price = GeneratedColumn<String>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    assetTypeCode,
    price,
    currency,
    fetchedAt,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_market_prices_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedMarketPricesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('asset_type_code')) {
      context.handle(
        _assetTypeCodeMeta,
        assetTypeCode.isAcceptableOrUnknown(
          data['asset_type_code']!,
          _assetTypeCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetTypeCodeMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedMarketPricesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedMarketPricesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      assetTypeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_type_code'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $CachedMarketPricesTableTable createAlias(String alias) {
    return $CachedMarketPricesTableTable(attachedDatabase, alias);
  }
}

class CachedMarketPricesTableData extends DataClass
    implements Insertable<CachedMarketPricesTableData> {
  final String id;
  final String assetTypeCode;
  final String price;
  final String currency;
  final DateTime fetchedAt;
  final DateTime? lastSyncedAt;
  const CachedMarketPricesTableData({
    required this.id,
    required this.assetTypeCode,
    required this.price,
    required this.currency,
    required this.fetchedAt,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['asset_type_code'] = Variable<String>(assetTypeCode);
    map['price'] = Variable<String>(price);
    map['currency'] = Variable<String>(currency);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  CachedMarketPricesTableCompanion toCompanion(bool nullToAbsent) {
    return CachedMarketPricesTableCompanion(
      id: Value(id),
      assetTypeCode: Value(assetTypeCode),
      price: Value(price),
      currency: Value(currency),
      fetchedAt: Value(fetchedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory CachedMarketPricesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedMarketPricesTableData(
      id: serializer.fromJson<String>(json['id']),
      assetTypeCode: serializer.fromJson<String>(json['assetTypeCode']),
      price: serializer.fromJson<String>(json['price']),
      currency: serializer.fromJson<String>(json['currency']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'assetTypeCode': serializer.toJson<String>(assetTypeCode),
      'price': serializer.toJson<String>(price),
      'currency': serializer.toJson<String>(currency),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  CachedMarketPricesTableData copyWith({
    String? id,
    String? assetTypeCode,
    String? price,
    String? currency,
    DateTime? fetchedAt,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => CachedMarketPricesTableData(
    id: id ?? this.id,
    assetTypeCode: assetTypeCode ?? this.assetTypeCode,
    price: price ?? this.price,
    currency: currency ?? this.currency,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  CachedMarketPricesTableData copyWithCompanion(
    CachedMarketPricesTableCompanion data,
  ) {
    return CachedMarketPricesTableData(
      id: data.id.present ? data.id.value : this.id,
      assetTypeCode: data.assetTypeCode.present
          ? data.assetTypeCode.value
          : this.assetTypeCode,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedMarketPricesTableData(')
          ..write('id: $id, ')
          ..write('assetTypeCode: $assetTypeCode, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, assetTypeCode, price, currency, fetchedAt, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedMarketPricesTableData &&
          other.id == this.id &&
          other.assetTypeCode == this.assetTypeCode &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.fetchedAt == this.fetchedAt &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class CachedMarketPricesTableCompanion
    extends UpdateCompanion<CachedMarketPricesTableData> {
  final Value<String> id;
  final Value<String> assetTypeCode;
  final Value<String> price;
  final Value<String> currency;
  final Value<DateTime> fetchedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const CachedMarketPricesTableCompanion({
    this.id = const Value.absent(),
    this.assetTypeCode = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedMarketPricesTableCompanion.insert({
    required String id,
    required String assetTypeCode,
    required String price,
    required String currency,
    required DateTime fetchedAt,
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       assetTypeCode = Value(assetTypeCode),
       price = Value(price),
       currency = Value(currency),
       fetchedAt = Value(fetchedAt);
  static Insertable<CachedMarketPricesTableData> custom({
    Expression<String>? id,
    Expression<String>? assetTypeCode,
    Expression<String>? price,
    Expression<String>? currency,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (assetTypeCode != null) 'asset_type_code': assetTypeCode,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedMarketPricesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? assetTypeCode,
    Value<String>? price,
    Value<String>? currency,
    Value<DateTime>? fetchedAt,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return CachedMarketPricesTableCompanion(
      id: id ?? this.id,
      assetTypeCode: assetTypeCode ?? this.assetTypeCode,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (assetTypeCode.present) {
      map['asset_type_code'] = Variable<String>(assetTypeCode.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedMarketPricesTableCompanion(')
          ..write('id: $id, ')
          ..write('assetTypeCode: $assetTypeCode, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedInflationRatesTableTable extends CachedInflationRatesTable
    with
        TableInfo<
          $CachedInflationRatesTableTable,
          CachedInflationRatesTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedInflationRatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<DateTime> month = GeneratedColumn<DateTime>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<String> rate = GeneratedColumn<String>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, month, rate, lastSyncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_inflation_rates_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedInflationRatesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedInflationRatesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedInflationRatesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}month'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rate'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $CachedInflationRatesTableTable createAlias(String alias) {
    return $CachedInflationRatesTableTable(attachedDatabase, alias);
  }
}

class CachedInflationRatesTableData extends DataClass
    implements Insertable<CachedInflationRatesTableData> {
  final String id;
  final DateTime month;
  final String rate;
  final DateTime? lastSyncedAt;
  const CachedInflationRatesTableData({
    required this.id,
    required this.month,
    required this.rate,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['month'] = Variable<DateTime>(month);
    map['rate'] = Variable<String>(rate);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  CachedInflationRatesTableCompanion toCompanion(bool nullToAbsent) {
    return CachedInflationRatesTableCompanion(
      id: Value(id),
      month: Value(month),
      rate: Value(rate),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory CachedInflationRatesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedInflationRatesTableData(
      id: serializer.fromJson<String>(json['id']),
      month: serializer.fromJson<DateTime>(json['month']),
      rate: serializer.fromJson<String>(json['rate']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'month': serializer.toJson<DateTime>(month),
      'rate': serializer.toJson<String>(rate),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  CachedInflationRatesTableData copyWith({
    String? id,
    DateTime? month,
    String? rate,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => CachedInflationRatesTableData(
    id: id ?? this.id,
    month: month ?? this.month,
    rate: rate ?? this.rate,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  CachedInflationRatesTableData copyWithCompanion(
    CachedInflationRatesTableCompanion data,
  ) {
    return CachedInflationRatesTableData(
      id: data.id.present ? data.id.value : this.id,
      month: data.month.present ? data.month.value : this.month,
      rate: data.rate.present ? data.rate.value : this.rate,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedInflationRatesTableData(')
          ..write('id: $id, ')
          ..write('month: $month, ')
          ..write('rate: $rate, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, month, rate, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedInflationRatesTableData &&
          other.id == this.id &&
          other.month == this.month &&
          other.rate == this.rate &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class CachedInflationRatesTableCompanion
    extends UpdateCompanion<CachedInflationRatesTableData> {
  final Value<String> id;
  final Value<DateTime> month;
  final Value<String> rate;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const CachedInflationRatesTableCompanion({
    this.id = const Value.absent(),
    this.month = const Value.absent(),
    this.rate = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedInflationRatesTableCompanion.insert({
    required String id,
    required DateTime month,
    required String rate,
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       month = Value(month),
       rate = Value(rate);
  static Insertable<CachedInflationRatesTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? month,
    Expression<String>? rate,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (month != null) 'month': month,
      if (rate != null) 'rate': rate,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedInflationRatesTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? month,
    Value<String>? rate,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return CachedInflationRatesTableCompanion(
      id: id ?? this.id,
      month: month ?? this.month,
      rate: rate ?? this.rate,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (month.present) {
      map['month'] = Variable<DateTime>(month.value);
    }
    if (rate.present) {
      map['rate'] = Variable<String>(rate.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedInflationRatesTableCompanion(')
          ..write('id: $id, ')
          ..write('month: $month, ')
          ..write('rate: $rate, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedPortfolioSnapshotsTableTable extends CachedPortfolioSnapshotsTable
    with
        TableInfo<
          $CachedPortfolioSnapshotsTableTable,
          CachedPortfolioSnapshotsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedPortfolioSnapshotsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nominalValueMeta = const VerificationMeta(
    'nominalValue',
  );
  @override
  late final GeneratedColumn<String> nominalValue = GeneratedColumn<String>(
    'nominal_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _realValueMeta = const VerificationMeta(
    'realValue',
  );
  @override
  late final GeneratedColumn<String> realValue = GeneratedColumn<String>(
    'real_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snapshotDateMeta = const VerificationMeta(
    'snapshotDate',
  );
  @override
  late final GeneratedColumn<DateTime> snapshotDate = GeneratedColumn<DateTime>(
    'snapshot_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    nominalValue,
    realValue,
    snapshotDate,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_portfolio_snapshots_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedPortfolioSnapshotsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('nominal_value')) {
      context.handle(
        _nominalValueMeta,
        nominalValue.isAcceptableOrUnknown(
          data['nominal_value']!,
          _nominalValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nominalValueMeta);
    }
    if (data.containsKey('real_value')) {
      context.handle(
        _realValueMeta,
        realValue.isAcceptableOrUnknown(data['real_value']!, _realValueMeta),
      );
    } else if (isInserting) {
      context.missing(_realValueMeta);
    }
    if (data.containsKey('snapshot_date')) {
      context.handle(
        _snapshotDateMeta,
        snapshotDate.isAcceptableOrUnknown(
          data['snapshot_date']!,
          _snapshotDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotDateMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedPortfolioSnapshotsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedPortfolioSnapshotsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      nominalValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nominal_value'],
      )!,
      realValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}real_value'],
      )!,
      snapshotDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}snapshot_date'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $CachedPortfolioSnapshotsTableTable createAlias(String alias) {
    return $CachedPortfolioSnapshotsTableTable(attachedDatabase, alias);
  }
}

class CachedPortfolioSnapshotsTableData extends DataClass
    implements Insertable<CachedPortfolioSnapshotsTableData> {
  final String id;
  final String userId;
  final String nominalValue;
  final String realValue;
  final DateTime snapshotDate;
  final DateTime? lastSyncedAt;
  const CachedPortfolioSnapshotsTableData({
    required this.id,
    required this.userId,
    required this.nominalValue,
    required this.realValue,
    required this.snapshotDate,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['nominal_value'] = Variable<String>(nominalValue);
    map['real_value'] = Variable<String>(realValue);
    map['snapshot_date'] = Variable<DateTime>(snapshotDate);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  CachedPortfolioSnapshotsTableCompanion toCompanion(bool nullToAbsent) {
    return CachedPortfolioSnapshotsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      nominalValue: Value(nominalValue),
      realValue: Value(realValue),
      snapshotDate: Value(snapshotDate),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory CachedPortfolioSnapshotsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedPortfolioSnapshotsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      nominalValue: serializer.fromJson<String>(json['nominalValue']),
      realValue: serializer.fromJson<String>(json['realValue']),
      snapshotDate: serializer.fromJson<DateTime>(json['snapshotDate']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'nominalValue': serializer.toJson<String>(nominalValue),
      'realValue': serializer.toJson<String>(realValue),
      'snapshotDate': serializer.toJson<DateTime>(snapshotDate),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  CachedPortfolioSnapshotsTableData copyWith({
    String? id,
    String? userId,
    String? nominalValue,
    String? realValue,
    DateTime? snapshotDate,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => CachedPortfolioSnapshotsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    nominalValue: nominalValue ?? this.nominalValue,
    realValue: realValue ?? this.realValue,
    snapshotDate: snapshotDate ?? this.snapshotDate,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  CachedPortfolioSnapshotsTableData copyWithCompanion(
    CachedPortfolioSnapshotsTableCompanion data,
  ) {
    return CachedPortfolioSnapshotsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      nominalValue: data.nominalValue.present
          ? data.nominalValue.value
          : this.nominalValue,
      realValue: data.realValue.present ? data.realValue.value : this.realValue,
      snapshotDate: data.snapshotDate.present
          ? data.snapshotDate.value
          : this.snapshotDate,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedPortfolioSnapshotsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nominalValue: $nominalValue, ')
          ..write('realValue: $realValue, ')
          ..write('snapshotDate: $snapshotDate, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    nominalValue,
    realValue,
    snapshotDate,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedPortfolioSnapshotsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.nominalValue == this.nominalValue &&
          other.realValue == this.realValue &&
          other.snapshotDate == this.snapshotDate &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class CachedPortfolioSnapshotsTableCompanion
    extends UpdateCompanion<CachedPortfolioSnapshotsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> nominalValue;
  final Value<String> realValue;
  final Value<DateTime> snapshotDate;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const CachedPortfolioSnapshotsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.nominalValue = const Value.absent(),
    this.realValue = const Value.absent(),
    this.snapshotDate = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedPortfolioSnapshotsTableCompanion.insert({
    required String id,
    required String userId,
    required String nominalValue,
    required String realValue,
    required DateTime snapshotDate,
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       nominalValue = Value(nominalValue),
       realValue = Value(realValue),
       snapshotDate = Value(snapshotDate);
  static Insertable<CachedPortfolioSnapshotsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? nominalValue,
    Expression<String>? realValue,
    Expression<DateTime>? snapshotDate,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (nominalValue != null) 'nominal_value': nominalValue,
      if (realValue != null) 'real_value': realValue,
      if (snapshotDate != null) 'snapshot_date': snapshotDate,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedPortfolioSnapshotsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? nominalValue,
    Value<String>? realValue,
    Value<DateTime>? snapshotDate,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return CachedPortfolioSnapshotsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nominalValue: nominalValue ?? this.nominalValue,
      realValue: realValue ?? this.realValue,
      snapshotDate: snapshotDate ?? this.snapshotDate,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (nominalValue.present) {
      map['nominal_value'] = Variable<String>(nominalValue.value);
    }
    if (realValue.present) {
      map['real_value'] = Variable<String>(realValue.value);
    }
    if (snapshotDate.present) {
      map['snapshot_date'] = Variable<DateTime>(snapshotDate.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedPortfolioSnapshotsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('nominalValue: $nominalValue, ')
          ..write('realValue: $realValue, ')
          ..write('snapshotDate: $snapshotDate, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedSavingsGoalsTableTable extends CachedSavingsGoalsTable
    with TableInfo<$CachedSavingsGoalsTableTable, CachedSavingsGoalsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSavingsGoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<String> targetAmount = GeneratedColumn<String>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAssetTypeCodeMeta =
      const VerificationMeta('targetAssetTypeCode');
  @override
  late final GeneratedColumn<String> targetAssetTypeCode =
      GeneratedColumn<String>(
        'target_asset_type_code',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentAmountMeta = const VerificationMeta(
    'currentAmount',
  );
  @override
  late final GeneratedColumn<String> currentAmount = GeneratedColumn<String>(
    'current_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('0'),
  );
  static const VerificationMeta _pendingSyncMeta = const VerificationMeta(
    'pendingSync',
  );
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
    'pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    targetAmount,
    targetAssetTypeCode,
    targetDate,
    currentAmount,
    pendingSync,
    lastSyncedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_savings_goals_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSavingsGoalsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('target_asset_type_code')) {
      context.handle(
        _targetAssetTypeCodeMeta,
        targetAssetTypeCode.isAcceptableOrUnknown(
          data['target_asset_type_code']!,
          _targetAssetTypeCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAssetTypeCodeMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
        _currentAmountMeta,
        currentAmount.isAcceptableOrUnknown(
          data['current_amount']!,
          _currentAmountMeta,
        ),
      );
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
        _pendingSyncMeta,
        pendingSync.isAcceptableOrUnknown(
          data['pending_sync']!,
          _pendingSyncMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedSavingsGoalsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSavingsGoalsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_amount'],
      )!,
      targetAssetTypeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_asset_type_code'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      )!,
      currentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_amount'],
      )!,
      pendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_sync'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedSavingsGoalsTableTable createAlias(String alias) {
    return $CachedSavingsGoalsTableTable(attachedDatabase, alias);
  }
}

class CachedSavingsGoalsTableData extends DataClass
    implements Insertable<CachedSavingsGoalsTableData> {
  final String id;
  final String userId;
  final String name;
  final String targetAmount;
  final String targetAssetTypeCode;
  final DateTime targetDate;
  final String currentAmount;
  final bool pendingSync;
  final DateTime? lastSyncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CachedSavingsGoalsTableData({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.targetAssetTypeCode,
    required this.targetDate,
    required this.currentAmount,
    required this.pendingSync,
    this.lastSyncedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['target_amount'] = Variable<String>(targetAmount);
    map['target_asset_type_code'] = Variable<String>(targetAssetTypeCode);
    map['target_date'] = Variable<DateTime>(targetDate);
    map['current_amount'] = Variable<String>(currentAmount);
    map['pending_sync'] = Variable<bool>(pendingSync);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedSavingsGoalsTableCompanion toCompanion(bool nullToAbsent) {
    return CachedSavingsGoalsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      targetAmount: Value(targetAmount),
      targetAssetTypeCode: Value(targetAssetTypeCode),
      targetDate: Value(targetDate),
      currentAmount: Value(currentAmount),
      pendingSync: Value(pendingSync),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedSavingsGoalsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSavingsGoalsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<String>(json['targetAmount']),
      targetAssetTypeCode: serializer.fromJson<String>(
        json['targetAssetTypeCode'],
      ),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      currentAmount: serializer.fromJson<String>(json['currentAmount']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<String>(targetAmount),
      'targetAssetTypeCode': serializer.toJson<String>(targetAssetTypeCode),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'currentAmount': serializer.toJson<String>(currentAmount),
      'pendingSync': serializer.toJson<bool>(pendingSync),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedSavingsGoalsTableData copyWith({
    String? id,
    String? userId,
    String? name,
    String? targetAmount,
    String? targetAssetTypeCode,
    DateTime? targetDate,
    String? currentAmount,
    bool? pendingSync,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CachedSavingsGoalsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    targetAmount: targetAmount ?? this.targetAmount,
    targetAssetTypeCode: targetAssetTypeCode ?? this.targetAssetTypeCode,
    targetDate: targetDate ?? this.targetDate,
    currentAmount: currentAmount ?? this.currentAmount,
    pendingSync: pendingSync ?? this.pendingSync,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedSavingsGoalsTableData copyWithCompanion(
    CachedSavingsGoalsTableCompanion data,
  ) {
    return CachedSavingsGoalsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      targetAssetTypeCode: data.targetAssetTypeCode.present
          ? data.targetAssetTypeCode.value
          : this.targetAssetTypeCode,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      pendingSync: data.pendingSync.present
          ? data.pendingSync.value
          : this.pendingSync,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSavingsGoalsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('targetAssetTypeCode: $targetAssetTypeCode, ')
          ..write('targetDate: $targetDate, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    targetAmount,
    targetAssetTypeCode,
    targetDate,
    currentAmount,
    pendingSync,
    lastSyncedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSavingsGoalsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.targetAssetTypeCode == this.targetAssetTypeCode &&
          other.targetDate == this.targetDate &&
          other.currentAmount == this.currentAmount &&
          other.pendingSync == this.pendingSync &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CachedSavingsGoalsTableCompanion
    extends UpdateCompanion<CachedSavingsGoalsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> targetAmount;
  final Value<String> targetAssetTypeCode;
  final Value<DateTime> targetDate;
  final Value<String> currentAmount;
  final Value<bool> pendingSync;
  final Value<DateTime?> lastSyncedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedSavingsGoalsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.targetAssetTypeCode = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSavingsGoalsTableCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String targetAmount,
    required String targetAssetTypeCode,
    required DateTime targetDate,
    this.currentAmount = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       targetAmount = Value(targetAmount),
       targetAssetTypeCode = Value(targetAssetTypeCode),
       targetDate = Value(targetDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedSavingsGoalsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? targetAmount,
    Expression<String>? targetAssetTypeCode,
    Expression<DateTime>? targetDate,
    Expression<String>? currentAmount,
    Expression<bool>? pendingSync,
    Expression<DateTime>? lastSyncedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (targetAssetTypeCode != null)
        'target_asset_type_code': targetAssetTypeCode,
      if (targetDate != null) 'target_date': targetDate,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSavingsGoalsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<String>? targetAmount,
    Value<String>? targetAssetTypeCode,
    Value<DateTime>? targetDate,
    Value<String>? currentAmount,
    Value<bool>? pendingSync,
    Value<DateTime?>? lastSyncedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedSavingsGoalsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      targetAssetTypeCode: targetAssetTypeCode ?? this.targetAssetTypeCode,
      targetDate: targetDate ?? this.targetDate,
      currentAmount: currentAmount ?? this.currentAmount,
      pendingSync: pendingSync ?? this.pendingSync,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<String>(targetAmount.value);
    }
    if (targetAssetTypeCode.present) {
      map['target_asset_type_code'] = Variable<String>(
        targetAssetTypeCode.value,
      );
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<String>(currentAmount.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSavingsGoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('targetAssetTypeCode: $targetAssetTypeCode, ')
          ..write('targetDate: $targetDate, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedAssetTypesTableTable extends CachedAssetTypesTable
    with TableInfo<$CachedAssetTypesTableTable, CachedAssetTypesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedAssetTypesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isMarketBasedMeta = const VerificationMeta(
    'isMarketBased',
  );
  @override
  late final GeneratedColumn<bool> isMarketBased = GeneratedColumn<bool>(
    'is_market_based',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_market_based" IN (0, 1))',
    ),
  );
  static const VerificationMeta _displayIconMeta = const VerificationMeta(
    'displayIcon',
  );
  @override
  late final GeneratedColumn<String> displayIcon = GeneratedColumn<String>(
    'display_icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    isMarketBased,
    displayIcon,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_asset_types_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedAssetTypesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_market_based')) {
      context.handle(
        _isMarketBasedMeta,
        isMarketBased.isAcceptableOrUnknown(
          data['is_market_based']!,
          _isMarketBasedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isMarketBasedMeta);
    }
    if (data.containsKey('display_icon')) {
      context.handle(
        _displayIconMeta,
        displayIcon.isAcceptableOrUnknown(
          data['display_icon']!,
          _displayIconMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedAssetTypesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedAssetTypesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isMarketBased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_market_based'],
      )!,
      displayIcon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_icon'],
      ),
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $CachedAssetTypesTableTable createAlias(String alias) {
    return $CachedAssetTypesTableTable(attachedDatabase, alias);
  }
}

class CachedAssetTypesTableData extends DataClass
    implements Insertable<CachedAssetTypesTableData> {
  final String id;
  final String code;
  final String name;
  final bool isMarketBased;
  final String? displayIcon;
  final DateTime? lastSyncedAt;
  const CachedAssetTypesTableData({
    required this.id,
    required this.code,
    required this.name,
    required this.isMarketBased,
    this.displayIcon,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['is_market_based'] = Variable<bool>(isMarketBased);
    if (!nullToAbsent || displayIcon != null) {
      map['display_icon'] = Variable<String>(displayIcon);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  CachedAssetTypesTableCompanion toCompanion(bool nullToAbsent) {
    return CachedAssetTypesTableCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      isMarketBased: Value(isMarketBased),
      displayIcon: displayIcon == null && nullToAbsent
          ? const Value.absent()
          : Value(displayIcon),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory CachedAssetTypesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedAssetTypesTableData(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      isMarketBased: serializer.fromJson<bool>(json['isMarketBased']),
      displayIcon: serializer.fromJson<String?>(json['displayIcon']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'isMarketBased': serializer.toJson<bool>(isMarketBased),
      'displayIcon': serializer.toJson<String?>(displayIcon),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  CachedAssetTypesTableData copyWith({
    String? id,
    String? code,
    String? name,
    bool? isMarketBased,
    Value<String?> displayIcon = const Value.absent(),
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => CachedAssetTypesTableData(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    isMarketBased: isMarketBased ?? this.isMarketBased,
    displayIcon: displayIcon.present ? displayIcon.value : this.displayIcon,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  CachedAssetTypesTableData copyWithCompanion(
    CachedAssetTypesTableCompanion data,
  ) {
    return CachedAssetTypesTableData(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      isMarketBased: data.isMarketBased.present
          ? data.isMarketBased.value
          : this.isMarketBased,
      displayIcon: data.displayIcon.present
          ? data.displayIcon.value
          : this.displayIcon,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedAssetTypesTableData(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('isMarketBased: $isMarketBased, ')
          ..write('displayIcon: $displayIcon, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, isMarketBased, displayIcon, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedAssetTypesTableData &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.isMarketBased == this.isMarketBased &&
          other.displayIcon == this.displayIcon &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class CachedAssetTypesTableCompanion
    extends UpdateCompanion<CachedAssetTypesTableData> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<bool> isMarketBased;
  final Value<String?> displayIcon;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const CachedAssetTypesTableCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.isMarketBased = const Value.absent(),
    this.displayIcon = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedAssetTypesTableCompanion.insert({
    required String id,
    required String code,
    required String name,
    required bool isMarketBased,
    this.displayIcon = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       isMarketBased = Value(isMarketBased);
  static Insertable<CachedAssetTypesTableData> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<bool>? isMarketBased,
    Expression<String>? displayIcon,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (isMarketBased != null) 'is_market_based': isMarketBased,
      if (displayIcon != null) 'display_icon': displayIcon,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedAssetTypesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<bool>? isMarketBased,
    Value<String?>? displayIcon,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return CachedAssetTypesTableCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      isMarketBased: isMarketBased ?? this.isMarketBased,
      displayIcon: displayIcon ?? this.displayIcon,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isMarketBased.present) {
      map['is_market_based'] = Variable<bool>(isMarketBased.value);
    }
    if (displayIcon.present) {
      map['display_icon'] = Variable<String>(displayIcon.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedAssetTypesTableCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('isMarketBased: $isMarketBased, ')
          ..write('displayIcon: $displayIcon, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedAssetsTableTable cachedAssetsTable =
      $CachedAssetsTableTable(this);
  late final $CachedAssetHistoryTableTable cachedAssetHistoryTable =
      $CachedAssetHistoryTableTable(this);
  late final $CachedMarketPricesTableTable cachedMarketPricesTable =
      $CachedMarketPricesTableTable(this);
  late final $CachedInflationRatesTableTable cachedInflationRatesTable =
      $CachedInflationRatesTableTable(this);
  late final $CachedPortfolioSnapshotsTableTable cachedPortfolioSnapshotsTable =
      $CachedPortfolioSnapshotsTableTable(this);
  late final $CachedSavingsGoalsTableTable cachedSavingsGoalsTable =
      $CachedSavingsGoalsTableTable(this);
  late final $CachedAssetTypesTableTable cachedAssetTypesTable =
      $CachedAssetTypesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedAssetsTable,
    cachedAssetHistoryTable,
    cachedMarketPricesTable,
    cachedInflationRatesTable,
    cachedPortfolioSnapshotsTable,
    cachedSavingsGoalsTable,
    cachedAssetTypesTable,
  ];
}

typedef $$CachedAssetsTableTableCreateCompanionBuilder =
    CachedAssetsTableCompanion Function({
      required String id,
      required String userId,
      required String assetTypeCode,
      required String assetTypeId,
      required String amount,
      required String priceAtEntry,
      required String currentUnitPrice,
      required DateTime entryDate,
      Value<String?> note,
      Value<bool> pendingSync,
      Value<DateTime?> lastSyncedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CachedAssetsTableTableUpdateCompanionBuilder =
    CachedAssetsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> assetTypeCode,
      Value<String> assetTypeId,
      Value<String> amount,
      Value<String> priceAtEntry,
      Value<String> currentUnitPrice,
      Value<DateTime> entryDate,
      Value<String?> note,
      Value<bool> pendingSync,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CachedAssetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedAssetsTableTable> {
  $$CachedAssetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetTypeCode => $composableBuilder(
    column: $table.assetTypeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetTypeId => $composableBuilder(
    column: $table.assetTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceAtEntry => $composableBuilder(
    column: $table.priceAtEntry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentUnitPrice => $composableBuilder(
    column: $table.currentUnitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedAssetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedAssetsTableTable> {
  $$CachedAssetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetTypeCode => $composableBuilder(
    column: $table.assetTypeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetTypeId => $composableBuilder(
    column: $table.assetTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceAtEntry => $composableBuilder(
    column: $table.priceAtEntry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentUnitPrice => $composableBuilder(
    column: $table.currentUnitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedAssetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedAssetsTableTable> {
  $$CachedAssetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get assetTypeCode => $composableBuilder(
    column: $table.assetTypeCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetTypeId => $composableBuilder(
    column: $table.assetTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get priceAtEntry => $composableBuilder(
    column: $table.priceAtEntry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentUnitPrice => $composableBuilder(
    column: $table.currentUnitPrice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedAssetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedAssetsTableTable,
          CachedAssetsTableData,
          $$CachedAssetsTableTableFilterComposer,
          $$CachedAssetsTableTableOrderingComposer,
          $$CachedAssetsTableTableAnnotationComposer,
          $$CachedAssetsTableTableCreateCompanionBuilder,
          $$CachedAssetsTableTableUpdateCompanionBuilder,
          (
            CachedAssetsTableData,
            BaseReferences<
              _$AppDatabase,
              $CachedAssetsTableTable,
              CachedAssetsTableData
            >,
          ),
          CachedAssetsTableData,
          PrefetchHooks Function()
        > {
  $$CachedAssetsTableTableTableManager(
    _$AppDatabase db,
    $CachedAssetsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAssetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedAssetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedAssetsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> assetTypeCode = const Value.absent(),
                Value<String> assetTypeId = const Value.absent(),
                Value<String> amount = const Value.absent(),
                Value<String> priceAtEntry = const Value.absent(),
                Value<String> currentUnitPrice = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAssetsTableCompanion(
                id: id,
                userId: userId,
                assetTypeCode: assetTypeCode,
                assetTypeId: assetTypeId,
                amount: amount,
                priceAtEntry: priceAtEntry,
                currentUnitPrice: currentUnitPrice,
                entryDate: entryDate,
                note: note,
                pendingSync: pendingSync,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String assetTypeCode,
                required String assetTypeId,
                required String amount,
                required String priceAtEntry,
                required String currentUnitPrice,
                required DateTime entryDate,
                Value<String?> note = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedAssetsTableCompanion.insert(
                id: id,
                userId: userId,
                assetTypeCode: assetTypeCode,
                assetTypeId: assetTypeId,
                amount: amount,
                priceAtEntry: priceAtEntry,
                currentUnitPrice: currentUnitPrice,
                entryDate: entryDate,
                note: note,
                pendingSync: pendingSync,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedAssetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedAssetsTableTable,
      CachedAssetsTableData,
      $$CachedAssetsTableTableFilterComposer,
      $$CachedAssetsTableTableOrderingComposer,
      $$CachedAssetsTableTableAnnotationComposer,
      $$CachedAssetsTableTableCreateCompanionBuilder,
      $$CachedAssetsTableTableUpdateCompanionBuilder,
      (
        CachedAssetsTableData,
        BaseReferences<
          _$AppDatabase,
          $CachedAssetsTableTable,
          CachedAssetsTableData
        >,
      ),
      CachedAssetsTableData,
      PrefetchHooks Function()
    >;
typedef $$CachedAssetHistoryTableTableCreateCompanionBuilder =
    CachedAssetHistoryTableCompanion Function({
      required String id,
      required String assetId,
      required String fieldName,
      Value<String?> oldValue,
      Value<String?> newValue,
      required DateTime changedAt,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$CachedAssetHistoryTableTableUpdateCompanionBuilder =
    CachedAssetHistoryTableCompanion Function({
      Value<String> id,
      Value<String> assetId,
      Value<String> fieldName,
      Value<String?> oldValue,
      Value<String?> newValue,
      Value<DateTime> changedAt,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

class $$CachedAssetHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedAssetHistoryTableTable> {
  $$CachedAssetHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedAssetHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedAssetHistoryTableTable> {
  $$CachedAssetHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetId => $composableBuilder(
    column: $table.assetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedAssetHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedAssetHistoryTableTable> {
  $$CachedAssetHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assetId =>
      $composableBuilder(column: $table.assetId, builder: (column) => column);

  GeneratedColumn<String> get fieldName =>
      $composableBuilder(column: $table.fieldName, builder: (column) => column);

  GeneratedColumn<String> get oldValue =>
      $composableBuilder(column: $table.oldValue, builder: (column) => column);

  GeneratedColumn<String> get newValue =>
      $composableBuilder(column: $table.newValue, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$CachedAssetHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedAssetHistoryTableTable,
          CachedAssetHistoryTableData,
          $$CachedAssetHistoryTableTableFilterComposer,
          $$CachedAssetHistoryTableTableOrderingComposer,
          $$CachedAssetHistoryTableTableAnnotationComposer,
          $$CachedAssetHistoryTableTableCreateCompanionBuilder,
          $$CachedAssetHistoryTableTableUpdateCompanionBuilder,
          (
            CachedAssetHistoryTableData,
            BaseReferences<
              _$AppDatabase,
              $CachedAssetHistoryTableTable,
              CachedAssetHistoryTableData
            >,
          ),
          CachedAssetHistoryTableData,
          PrefetchHooks Function()
        > {
  $$CachedAssetHistoryTableTableTableManager(
    _$AppDatabase db,
    $CachedAssetHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAssetHistoryTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedAssetHistoryTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedAssetHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> assetId = const Value.absent(),
                Value<String> fieldName = const Value.absent(),
                Value<String?> oldValue = const Value.absent(),
                Value<String?> newValue = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAssetHistoryTableCompanion(
                id: id,
                assetId: assetId,
                fieldName: fieldName,
                oldValue: oldValue,
                newValue: newValue,
                changedAt: changedAt,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String assetId,
                required String fieldName,
                Value<String?> oldValue = const Value.absent(),
                Value<String?> newValue = const Value.absent(),
                required DateTime changedAt,
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAssetHistoryTableCompanion.insert(
                id: id,
                assetId: assetId,
                fieldName: fieldName,
                oldValue: oldValue,
                newValue: newValue,
                changedAt: changedAt,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedAssetHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedAssetHistoryTableTable,
      CachedAssetHistoryTableData,
      $$CachedAssetHistoryTableTableFilterComposer,
      $$CachedAssetHistoryTableTableOrderingComposer,
      $$CachedAssetHistoryTableTableAnnotationComposer,
      $$CachedAssetHistoryTableTableCreateCompanionBuilder,
      $$CachedAssetHistoryTableTableUpdateCompanionBuilder,
      (
        CachedAssetHistoryTableData,
        BaseReferences<
          _$AppDatabase,
          $CachedAssetHistoryTableTable,
          CachedAssetHistoryTableData
        >,
      ),
      CachedAssetHistoryTableData,
      PrefetchHooks Function()
    >;
typedef $$CachedMarketPricesTableTableCreateCompanionBuilder =
    CachedMarketPricesTableCompanion Function({
      required String id,
      required String assetTypeCode,
      required String price,
      required String currency,
      required DateTime fetchedAt,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$CachedMarketPricesTableTableUpdateCompanionBuilder =
    CachedMarketPricesTableCompanion Function({
      Value<String> id,
      Value<String> assetTypeCode,
      Value<String> price,
      Value<String> currency,
      Value<DateTime> fetchedAt,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

class $$CachedMarketPricesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedMarketPricesTableTable> {
  $$CachedMarketPricesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetTypeCode => $composableBuilder(
    column: $table.assetTypeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedMarketPricesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedMarketPricesTableTable> {
  $$CachedMarketPricesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetTypeCode => $composableBuilder(
    column: $table.assetTypeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedMarketPricesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedMarketPricesTableTable> {
  $$CachedMarketPricesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get assetTypeCode => $composableBuilder(
    column: $table.assetTypeCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$CachedMarketPricesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedMarketPricesTableTable,
          CachedMarketPricesTableData,
          $$CachedMarketPricesTableTableFilterComposer,
          $$CachedMarketPricesTableTableOrderingComposer,
          $$CachedMarketPricesTableTableAnnotationComposer,
          $$CachedMarketPricesTableTableCreateCompanionBuilder,
          $$CachedMarketPricesTableTableUpdateCompanionBuilder,
          (
            CachedMarketPricesTableData,
            BaseReferences<
              _$AppDatabase,
              $CachedMarketPricesTableTable,
              CachedMarketPricesTableData
            >,
          ),
          CachedMarketPricesTableData,
          PrefetchHooks Function()
        > {
  $$CachedMarketPricesTableTableTableManager(
    _$AppDatabase db,
    $CachedMarketPricesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedMarketPricesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedMarketPricesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedMarketPricesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> assetTypeCode = const Value.absent(),
                Value<String> price = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMarketPricesTableCompanion(
                id: id,
                assetTypeCode: assetTypeCode,
                price: price,
                currency: currency,
                fetchedAt: fetchedAt,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String assetTypeCode,
                required String price,
                required String currency,
                required DateTime fetchedAt,
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedMarketPricesTableCompanion.insert(
                id: id,
                assetTypeCode: assetTypeCode,
                price: price,
                currency: currency,
                fetchedAt: fetchedAt,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedMarketPricesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedMarketPricesTableTable,
      CachedMarketPricesTableData,
      $$CachedMarketPricesTableTableFilterComposer,
      $$CachedMarketPricesTableTableOrderingComposer,
      $$CachedMarketPricesTableTableAnnotationComposer,
      $$CachedMarketPricesTableTableCreateCompanionBuilder,
      $$CachedMarketPricesTableTableUpdateCompanionBuilder,
      (
        CachedMarketPricesTableData,
        BaseReferences<
          _$AppDatabase,
          $CachedMarketPricesTableTable,
          CachedMarketPricesTableData
        >,
      ),
      CachedMarketPricesTableData,
      PrefetchHooks Function()
    >;
typedef $$CachedInflationRatesTableTableCreateCompanionBuilder =
    CachedInflationRatesTableCompanion Function({
      required String id,
      required DateTime month,
      required String rate,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$CachedInflationRatesTableTableUpdateCompanionBuilder =
    CachedInflationRatesTableCompanion Function({
      Value<String> id,
      Value<DateTime> month,
      Value<String> rate,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

class $$CachedInflationRatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedInflationRatesTableTable> {
  $$CachedInflationRatesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedInflationRatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedInflationRatesTableTable> {
  $$CachedInflationRatesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedInflationRatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedInflationRatesTableTable> {
  $$CachedInflationRatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$CachedInflationRatesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedInflationRatesTableTable,
          CachedInflationRatesTableData,
          $$CachedInflationRatesTableTableFilterComposer,
          $$CachedInflationRatesTableTableOrderingComposer,
          $$CachedInflationRatesTableTableAnnotationComposer,
          $$CachedInflationRatesTableTableCreateCompanionBuilder,
          $$CachedInflationRatesTableTableUpdateCompanionBuilder,
          (
            CachedInflationRatesTableData,
            BaseReferences<
              _$AppDatabase,
              $CachedInflationRatesTableTable,
              CachedInflationRatesTableData
            >,
          ),
          CachedInflationRatesTableData,
          PrefetchHooks Function()
        > {
  $$CachedInflationRatesTableTableTableManager(
    _$AppDatabase db,
    $CachedInflationRatesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedInflationRatesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedInflationRatesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedInflationRatesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> month = const Value.absent(),
                Value<String> rate = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedInflationRatesTableCompanion(
                id: id,
                month: month,
                rate: rate,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime month,
                required String rate,
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedInflationRatesTableCompanion.insert(
                id: id,
                month: month,
                rate: rate,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedInflationRatesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedInflationRatesTableTable,
      CachedInflationRatesTableData,
      $$CachedInflationRatesTableTableFilterComposer,
      $$CachedInflationRatesTableTableOrderingComposer,
      $$CachedInflationRatesTableTableAnnotationComposer,
      $$CachedInflationRatesTableTableCreateCompanionBuilder,
      $$CachedInflationRatesTableTableUpdateCompanionBuilder,
      (
        CachedInflationRatesTableData,
        BaseReferences<
          _$AppDatabase,
          $CachedInflationRatesTableTable,
          CachedInflationRatesTableData
        >,
      ),
      CachedInflationRatesTableData,
      PrefetchHooks Function()
    >;
typedef $$CachedPortfolioSnapshotsTableTableCreateCompanionBuilder =
    CachedPortfolioSnapshotsTableCompanion Function({
      required String id,
      required String userId,
      required String nominalValue,
      required String realValue,
      required DateTime snapshotDate,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$CachedPortfolioSnapshotsTableTableUpdateCompanionBuilder =
    CachedPortfolioSnapshotsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> nominalValue,
      Value<String> realValue,
      Value<DateTime> snapshotDate,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

class $$CachedPortfolioSnapshotsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedPortfolioSnapshotsTableTable> {
  $$CachedPortfolioSnapshotsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nominalValue => $composableBuilder(
    column: $table.nominalValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get realValue => $composableBuilder(
    column: $table.realValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get snapshotDate => $composableBuilder(
    column: $table.snapshotDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedPortfolioSnapshotsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedPortfolioSnapshotsTableTable> {
  $$CachedPortfolioSnapshotsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nominalValue => $composableBuilder(
    column: $table.nominalValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get realValue => $composableBuilder(
    column: $table.realValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get snapshotDate => $composableBuilder(
    column: $table.snapshotDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedPortfolioSnapshotsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedPortfolioSnapshotsTableTable> {
  $$CachedPortfolioSnapshotsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get nominalValue => $composableBuilder(
    column: $table.nominalValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get realValue =>
      $composableBuilder(column: $table.realValue, builder: (column) => column);

  GeneratedColumn<DateTime> get snapshotDate => $composableBuilder(
    column: $table.snapshotDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$CachedPortfolioSnapshotsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedPortfolioSnapshotsTableTable,
          CachedPortfolioSnapshotsTableData,
          $$CachedPortfolioSnapshotsTableTableFilterComposer,
          $$CachedPortfolioSnapshotsTableTableOrderingComposer,
          $$CachedPortfolioSnapshotsTableTableAnnotationComposer,
          $$CachedPortfolioSnapshotsTableTableCreateCompanionBuilder,
          $$CachedPortfolioSnapshotsTableTableUpdateCompanionBuilder,
          (
            CachedPortfolioSnapshotsTableData,
            BaseReferences<
              _$AppDatabase,
              $CachedPortfolioSnapshotsTableTable,
              CachedPortfolioSnapshotsTableData
            >,
          ),
          CachedPortfolioSnapshotsTableData,
          PrefetchHooks Function()
        > {
  $$CachedPortfolioSnapshotsTableTableTableManager(
    _$AppDatabase db,
    $CachedPortfolioSnapshotsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedPortfolioSnapshotsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedPortfolioSnapshotsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedPortfolioSnapshotsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> nominalValue = const Value.absent(),
                Value<String> realValue = const Value.absent(),
                Value<DateTime> snapshotDate = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPortfolioSnapshotsTableCompanion(
                id: id,
                userId: userId,
                nominalValue: nominalValue,
                realValue: realValue,
                snapshotDate: snapshotDate,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String nominalValue,
                required String realValue,
                required DateTime snapshotDate,
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedPortfolioSnapshotsTableCompanion.insert(
                id: id,
                userId: userId,
                nominalValue: nominalValue,
                realValue: realValue,
                snapshotDate: snapshotDate,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedPortfolioSnapshotsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedPortfolioSnapshotsTableTable,
      CachedPortfolioSnapshotsTableData,
      $$CachedPortfolioSnapshotsTableTableFilterComposer,
      $$CachedPortfolioSnapshotsTableTableOrderingComposer,
      $$CachedPortfolioSnapshotsTableTableAnnotationComposer,
      $$CachedPortfolioSnapshotsTableTableCreateCompanionBuilder,
      $$CachedPortfolioSnapshotsTableTableUpdateCompanionBuilder,
      (
        CachedPortfolioSnapshotsTableData,
        BaseReferences<
          _$AppDatabase,
          $CachedPortfolioSnapshotsTableTable,
          CachedPortfolioSnapshotsTableData
        >,
      ),
      CachedPortfolioSnapshotsTableData,
      PrefetchHooks Function()
    >;
typedef $$CachedSavingsGoalsTableTableCreateCompanionBuilder =
    CachedSavingsGoalsTableCompanion Function({
      required String id,
      required String userId,
      required String name,
      required String targetAmount,
      required String targetAssetTypeCode,
      required DateTime targetDate,
      Value<String> currentAmount,
      Value<bool> pendingSync,
      Value<DateTime?> lastSyncedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CachedSavingsGoalsTableTableUpdateCompanionBuilder =
    CachedSavingsGoalsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<String> targetAmount,
      Value<String> targetAssetTypeCode,
      Value<DateTime> targetDate,
      Value<String> currentAmount,
      Value<bool> pendingSync,
      Value<DateTime?> lastSyncedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CachedSavingsGoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedSavingsGoalsTableTable> {
  $$CachedSavingsGoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetAssetTypeCode => $composableBuilder(
    column: $table.targetAssetTypeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSavingsGoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedSavingsGoalsTableTable> {
  $$CachedSavingsGoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetAssetTypeCode => $composableBuilder(
    column: $table.targetAssetTypeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSavingsGoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedSavingsGoalsTableTable> {
  $$CachedSavingsGoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetAssetTypeCode => $composableBuilder(
    column: $table.targetAssetTypeCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedSavingsGoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedSavingsGoalsTableTable,
          CachedSavingsGoalsTableData,
          $$CachedSavingsGoalsTableTableFilterComposer,
          $$CachedSavingsGoalsTableTableOrderingComposer,
          $$CachedSavingsGoalsTableTableAnnotationComposer,
          $$CachedSavingsGoalsTableTableCreateCompanionBuilder,
          $$CachedSavingsGoalsTableTableUpdateCompanionBuilder,
          (
            CachedSavingsGoalsTableData,
            BaseReferences<
              _$AppDatabase,
              $CachedSavingsGoalsTableTable,
              CachedSavingsGoalsTableData
            >,
          ),
          CachedSavingsGoalsTableData,
          PrefetchHooks Function()
        > {
  $$CachedSavingsGoalsTableTableTableManager(
    _$AppDatabase db,
    $CachedSavingsGoalsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSavingsGoalsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedSavingsGoalsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedSavingsGoalsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> targetAmount = const Value.absent(),
                Value<String> targetAssetTypeCode = const Value.absent(),
                Value<DateTime> targetDate = const Value.absent(),
                Value<String> currentAmount = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSavingsGoalsTableCompanion(
                id: id,
                userId: userId,
                name: name,
                targetAmount: targetAmount,
                targetAssetTypeCode: targetAssetTypeCode,
                targetDate: targetDate,
                currentAmount: currentAmount,
                pendingSync: pendingSync,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required String targetAmount,
                required String targetAssetTypeCode,
                required DateTime targetDate,
                Value<String> currentAmount = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedSavingsGoalsTableCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                targetAmount: targetAmount,
                targetAssetTypeCode: targetAssetTypeCode,
                targetDate: targetDate,
                currentAmount: currentAmount,
                pendingSync: pendingSync,
                lastSyncedAt: lastSyncedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSavingsGoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedSavingsGoalsTableTable,
      CachedSavingsGoalsTableData,
      $$CachedSavingsGoalsTableTableFilterComposer,
      $$CachedSavingsGoalsTableTableOrderingComposer,
      $$CachedSavingsGoalsTableTableAnnotationComposer,
      $$CachedSavingsGoalsTableTableCreateCompanionBuilder,
      $$CachedSavingsGoalsTableTableUpdateCompanionBuilder,
      (
        CachedSavingsGoalsTableData,
        BaseReferences<
          _$AppDatabase,
          $CachedSavingsGoalsTableTable,
          CachedSavingsGoalsTableData
        >,
      ),
      CachedSavingsGoalsTableData,
      PrefetchHooks Function()
    >;
typedef $$CachedAssetTypesTableTableCreateCompanionBuilder =
    CachedAssetTypesTableCompanion Function({
      required String id,
      required String code,
      required String name,
      required bool isMarketBased,
      Value<String?> displayIcon,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$CachedAssetTypesTableTableUpdateCompanionBuilder =
    CachedAssetTypesTableCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<bool> isMarketBased,
      Value<String?> displayIcon,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

class $$CachedAssetTypesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedAssetTypesTableTable> {
  $$CachedAssetTypesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMarketBased => $composableBuilder(
    column: $table.isMarketBased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayIcon => $composableBuilder(
    column: $table.displayIcon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedAssetTypesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedAssetTypesTableTable> {
  $$CachedAssetTypesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMarketBased => $composableBuilder(
    column: $table.isMarketBased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayIcon => $composableBuilder(
    column: $table.displayIcon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedAssetTypesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedAssetTypesTableTable> {
  $$CachedAssetTypesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isMarketBased => $composableBuilder(
    column: $table.isMarketBased,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayIcon => $composableBuilder(
    column: $table.displayIcon,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$CachedAssetTypesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedAssetTypesTableTable,
          CachedAssetTypesTableData,
          $$CachedAssetTypesTableTableFilterComposer,
          $$CachedAssetTypesTableTableOrderingComposer,
          $$CachedAssetTypesTableTableAnnotationComposer,
          $$CachedAssetTypesTableTableCreateCompanionBuilder,
          $$CachedAssetTypesTableTableUpdateCompanionBuilder,
          (
            CachedAssetTypesTableData,
            BaseReferences<
              _$AppDatabase,
              $CachedAssetTypesTableTable,
              CachedAssetTypesTableData
            >,
          ),
          CachedAssetTypesTableData,
          PrefetchHooks Function()
        > {
  $$CachedAssetTypesTableTableTableManager(
    _$AppDatabase db,
    $CachedAssetTypesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedAssetTypesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedAssetTypesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedAssetTypesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isMarketBased = const Value.absent(),
                Value<String?> displayIcon = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAssetTypesTableCompanion(
                id: id,
                code: code,
                name: name,
                isMarketBased: isMarketBased,
                displayIcon: displayIcon,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required bool isMarketBased,
                Value<String?> displayIcon = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedAssetTypesTableCompanion.insert(
                id: id,
                code: code,
                name: name,
                isMarketBased: isMarketBased,
                displayIcon: displayIcon,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedAssetTypesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedAssetTypesTableTable,
      CachedAssetTypesTableData,
      $$CachedAssetTypesTableTableFilterComposer,
      $$CachedAssetTypesTableTableOrderingComposer,
      $$CachedAssetTypesTableTableAnnotationComposer,
      $$CachedAssetTypesTableTableCreateCompanionBuilder,
      $$CachedAssetTypesTableTableUpdateCompanionBuilder,
      (
        CachedAssetTypesTableData,
        BaseReferences<
          _$AppDatabase,
          $CachedAssetTypesTableTable,
          CachedAssetTypesTableData
        >,
      ),
      CachedAssetTypesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedAssetsTableTableTableManager get cachedAssetsTable =>
      $$CachedAssetsTableTableTableManager(_db, _db.cachedAssetsTable);
  $$CachedAssetHistoryTableTableTableManager get cachedAssetHistoryTable =>
      $$CachedAssetHistoryTableTableTableManager(
        _db,
        _db.cachedAssetHistoryTable,
      );
  $$CachedMarketPricesTableTableTableManager get cachedMarketPricesTable =>
      $$CachedMarketPricesTableTableTableManager(
        _db,
        _db.cachedMarketPricesTable,
      );
  $$CachedInflationRatesTableTableTableManager get cachedInflationRatesTable =>
      $$CachedInflationRatesTableTableTableManager(
        _db,
        _db.cachedInflationRatesTable,
      );
  $$CachedPortfolioSnapshotsTableTableTableManager
  get cachedPortfolioSnapshotsTable =>
      $$CachedPortfolioSnapshotsTableTableTableManager(
        _db,
        _db.cachedPortfolioSnapshotsTable,
      );
  $$CachedSavingsGoalsTableTableTableManager get cachedSavingsGoalsTable =>
      $$CachedSavingsGoalsTableTableTableManager(
        _db,
        _db.cachedSavingsGoalsTable,
      );
  $$CachedAssetTypesTableTableTableManager get cachedAssetTypesTable =>
      $$CachedAssetTypesTableTableTableManager(_db, _db.cachedAssetTypesTable);
}

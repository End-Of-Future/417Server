--梦魇巨龙 迦拉克隆
function c88888856.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,88888856+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c88888856.accon)  
	e1:SetTarget(c88888856.actg) 
	e1:SetOperation(c88888856.acop) 
	c:RegisterEffect(e1) 
	--token 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c88888856.tkcost) 
	e2:SetTarget(c88888856.tktg) 
	e2:SetOperation(c88888856.tkop) 
	c:RegisterEffect(e2) 
	c88888856.field_effect=e2 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_LEAVE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(c88888856.thtg) 
	e3:SetOperation(c88888856.thop) 
	c:RegisterEffect(e3) 
	--to hand  
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOHAND) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_SUMMON_SUCCESS) 
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetRange(LOCATION_GRAVE) 
	e4:SetCountLimit(1,18888856+EFFECT_COUNT_CODE_DUEL) 
	e4:SetTarget(c88888856.xthtg) 
	e4:SetOperation(c88888856.xthop) 
	c:RegisterEffect(e4) 
	local e5=e4:Clone() 
	e5:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e5) 
	local e6=e4:Clone() 
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS) 
	c:RegisterEffect(e6) 
end
c88888856.SetCard_A_jlcl=true 
function c88888856.ackfil(c) 
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) 
end 
function c88888856.accon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c88888856.ackfil,tp,LOCATION_MZONE,0,1,nil) 
end  
function c88888856.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,2,nil) end   
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888856,5))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888856,5))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND) 
end 
function c88888856.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil) 
	if g:GetCount()>=2 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
	if Duel.GetFlagEffect(tp,88888856)~=0 then 
	local x=0 
	if Duel.GetFlagEffect(tp,88888856)==1 then x=1 end 
	if Duel.GetFlagEffect(tp,88888856)==2 then x=2 end 
	if Duel.GetFlagEffect(tp,88888856)>=3 then x=3 end  
	Duel.Draw(tp,x,REASON_EFFECT)  
	end 
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE) 
	e2:SetTargetRange(LOCATION_HAND,0) 
	e2:SetValue(0x1) 
	e2:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e2,tp) 
	end 
end 
function c88888856.thfil(c) 
	return c:IsRace(RACE_DRAGON) and c:IsAbleToHand()  
end 
function c88888856.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c88888856.thfil,tp,LOCATION_DECK+LOCATION_MZONE+LOCATION_REMOVED,0,1,nil) end 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888856,7))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888856,7))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_MZONE+LOCATION_REMOVED) 
end  
function c88888856.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88888856.thfil,tp,LOCATION_DECK+LOCATION_MZONE+LOCATION_REMOVED,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end
function c88888856.xthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end  
function c88888856.xthop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 
function c88888856.tkctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON)   
end 
function c88888856.tkcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c88888856.tkctfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c88888856.tkctfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
end 
function c88888856.tktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,88888857,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_DRAGON,ATTRIBUTE_DARK,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end   
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888856,6))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888856,6))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0) 
end 
function c88888856.tkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsPlayerCanSpecialSummonMonster(tp,88888857,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_DRAGON,ATTRIBUTE_DARK,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local token=Duel.CreateToken(tp,88888857)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then 
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetRange(LOCATION_MZONE) 
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	e5:SetValue(1)
	token:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	token:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(function(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION end)
	token:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	token:RegisterEffect(e8)
	local e9=e5:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	token:RegisterEffect(e9)
	local op=0 
	op=Duel.SelectOption(tp,aux.Stringid(88888856,1),aux.Stringid(88888856,2),aux.Stringid(88888856,3),aux.Stringid(88888856,4)) 
	if op==0 then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(88888856,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(c88888856.tkhtg) 
	e1:SetOperation(c88888856.tkhop) 
	token:RegisterEffect(e1) 
	elseif op==1 then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(88888856,2))
	e1:SetCategory(CATEGORY_DAMAGE) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(c88888856.tkdtg) 
	e1:SetOperation(c88888856.tkdop) 
	token:RegisterEffect(e1) 
	elseif op==2 then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(88888856,3))
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(c88888856.tkdmtg) 
	e1:SetOperation(c88888856.tkdmop) 
	token:RegisterEffect(e1) 
	elseif op==3 then 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(88888856,4))
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(c88888856.tkdstg) 
	e1:SetOperation(c88888856.tkdsop) 
	token:RegisterEffect(e1) 
	end 
	end   
	end  
	Duel.RegisterFlagEffect(tp,88888856,RESET_PHASE+PHASE_END,0,1) 
end 
function c88888856.tkhfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c88888856.tkhtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c88888856.tkhfil,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c88888856.tkhop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c88888856.tkhfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.ShuffleDeck(tp)
		tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c88888856.tkdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end 
function c88888856.tkdop(e,tp,eg,ep,ev,re,r,rp) 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c88888856.tkdmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE) 
end 
function c88888856.tkdmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
	local dg=g:RandomSelect(tp,1) 
	Duel.Destroy(dg,REASON_EFFECT) 
	end 
end 
function c88888856.tkdstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD) 
end 
function c88888856.tkdsop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if g:GetCount()>0 then 
	local dg=g:RandomSelect(tp,1) 
	Duel.Destroy(dg,REASON_EFFECT) 
	end 
end 





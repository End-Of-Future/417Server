--天使的圣光龙骑士
function c27819030.initial_effect(c) 
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	-- 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36898537,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c27819030.atkcon)
	e1:SetOperation(c27819030.atkop)
	c:RegisterEffect(e1) 
	--dis 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c27819030.discon)
	e2:SetOperation(c27819030.disop)
	c:RegisterEffect(e2)  
	--equip 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1)
	e3:SetCondition(c27819030.eqcon) 
	e3:SetTarget(c27819030.eqtg)
	e3:SetOperation(c27819030.eqop)
	c:RegisterEffect(e3) 
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c27819030.eqcheck)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(27819030,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c27819030.spcon2)
	e5:SetTarget(c27819030.sptg2)
	e5:SetOperation(c27819030.spop2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end 
c27819030.SetCard_XXLight=true  
function c27819030.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local mg=e:GetHandler():GetMaterial()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and mg:GetSum(Card.GetBaseAttack)>0
end 
function c27819030.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local mg=e:GetHandler():GetMaterial() 
	local atk=mg:GetSum(Card.GetBaseAttack)  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(atk/2)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end 
function c27819030.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler() 
	return re:IsActiveType(TYPE_MONSTER) and rc:IsAttackBelow(e:GetHandler():GetAttack()) and rp==1-tp and Duel.GetFlagEffect(tp,27819030)==0 
end 
function c27819030.disop(e,tp,eg,ep,ev,re,r,rp) 
	if Duel.GetFlagEffect(tp,27819030)==0 and Duel.SelectYesNo(tp,aux.Stringid(27819030,0)) then 
	Duel.Hint(HINT_CARD,0,27819030) 
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Destroy(re:GetHandler(),REASON_EFFECT) 
	Duel.RegisterFlagEffect(tp,27819030,RESET_PHASE+PHASE_END,0,1)
	end  
	end 
end 
function c27819030.eqfil(c) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) 
end 
function c27819030.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27819030.eqfil,1,nil) 
end 
function c27819030.eqtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_GRAVE)  
end 
function c27819030.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=eg:Filter(c27819030.eqfil,nil)
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c27819030.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(300)
		tc:RegisterEffect(e2)
	end
	end 
end 
function c27819030.eqlimit(e,c)
	return e:GetOwner()==c
end
function c27819030.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	local g=e:GetHandler():GetEquipGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c27819030.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c27819030.spfilter2(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27819030.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject():GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g and g:IsExists(c27819030.spfilter2,1,nil,e,tp) end
	local sg=g:Filter(c27819030.spfilter2,nil,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c27819030.spop2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end













   